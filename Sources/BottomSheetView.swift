import UIKit

public protocol BottomSheetViewDelegate {
  func willMove(to: BottomSheetPosition)
  func didMove(to: BottomSheetPosition)
}

public final class BottomSheetView: UIView {

  // MARK: - Properties

  public var delegate: BottomSheetViewDelegate?

  public var layout = DefaultBottomSheetLayout()
  public var appearance = BottomSheetAppearance() {
    didSet {
      setupView()
    }
  }

  /// Sets the BottomSheet Position is enabling tip mode.
  /// If set to `false`, only two modes, full and middle, are set
  /// default value is `true`
  public var isTipEnabled: Bool = true

  private var currentPosition: BottomSheetPosition = .half

  private var isContentScrollViewScrolling = false
  private var capturedContentScrollViewOffsetY: CGFloat = .zero


  // MARK: - UI

  private weak var parentViewController: UIViewController? {
    willSet {
      guard let parentViewController = newValue else { return }
      configureBottomSheet(parentViewController)
    }
  }
  private weak var contentViewController: UIViewController? {
    willSet {
      /// configureContentView 내부에서 parentView의 safeArea 값들을 가져오는 게 있는데
      /// 메인 쓰레드에서 가져오지 않으면 정확한 값을 가져오지 못하기 때문에 메인 쓰레드에서 함수 호출.
      // TODO: 기술 부채 해결
      DispatchQueue.main.async { [weak self] in
        self?.configureContentView(newValue)
      }
    }
  }

  private var topConstraint: NSLayoutConstraint?
  private var contentScrollView: UIScrollView?

  private let grabberContainerView = UIView()
  private let grabberView = UIView()


  // MARK: - LifeCyele

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Setup

  private func setup() {
    setupLayout()
    setupView()
    setupGesture()
  }

  // MARK: - Setup Layout

  private func setupLayout() {
    setupGrabberContainerLayout()
    setupGrabberLayout()
  }

  private func setupGrabberContainerLayout() {
    addSubview(grabberContainerView)
    grabberContainerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      grabberContainerView.topAnchor.constraint(equalTo: topAnchor),
      grabberContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      grabberContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      grabberContainerView.heightAnchor.constraint(equalToConstant: appearance.grabberHeight + 24)
    ])
  }

  private func setupGrabberLayout() {
    grabberContainerView.addSubview(grabberView)
    grabberView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      grabberView.centerXAnchor.constraint(equalTo: grabberContainerView.centerXAnchor),
      grabberView.centerYAnchor.constraint(equalTo: grabberContainerView.centerYAnchor),
      grabberView.widthAnchor.constraint(equalToConstant: appearance.grabberWidth),
      grabberView.heightAnchor.constraint(equalToConstant: appearance.grabberHeight)
    ])
  }

  // MARK: - Setup Views

  private func setupView() {
    setupBaseView()
    setupGrabberView()
  }

  private func setupBaseView() {
    backgroundColor = appearance.backgroundColor

    layer.cornerRadius = appearance.bottomSheetCornerRadius
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }

  private func setupGrabberView() {
    grabberView.backgroundColor = appearance.grabberBackgroundColor
    grabberView.layer.cornerRadius = appearance.grabberHeight / 2
  }


  // MARK: - Setup Gestures

  private func setupGesture() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
    addGestureRecognizer(panGestureRecognizer)
  }

  @objc
  private func didPan(_ sender: UIPanGestureRecognizer) {
    guard let parentViewController else { return }

    let translation = sender.translation(in: self)
    let panVelocity = sender.velocity(in: self).y

    switch sender.state {
    case .changed:
      defer {
        setNeedsLayout()
        sender.setTranslation(.zero, in: self)
      }

      let minimumPositionStandard: BottomSheetPosition = isTipEnabled ? .tip : .half
      let height = layout.anchoring(of: minimumPositionStandard).height(with: parentViewController)

      let isMinimumPositionAndDown = (frame.height <= height) && (panVelocity >= 0)
      let isMaximumPositionAndUp = frame.height > parentViewController.view.frame.height - parentViewController.view.safeAreaInsets.top

      guard isMinimumPositionAndDown == false else {
        topConstraint?.constant += translation.y * 0.5
        return
      }

      guard isMaximumPositionAndUp == false else {
        topConstraint?.constant += translation.y * 0.2
        return
      }

      topConstraint?.constant += translation.y

    case .ended:
      let isPanningUpWithSpeed = panVelocity < -500
      let isPanningDownWithSpeed = panVelocity > 500

      if isPanningDownWithSpeed {
        let destination: BottomSheetPosition = isTipEnabled && (currentPosition == .half) ? .tip : .half
        move(to: destination)
        return
      }

      if isPanningUpWithSpeed {
        let destination: BottomSheetPosition = currentPosition == .tip ? .half : .full
        move(to: destination)
        return
      }

      guard let closestDestination = BottomSheetPosition.allCases.min(by: {
        abs(layout.anchoring(of: $0).height(with: parentViewController) - frame.height)
        < abs(layout.anchoring(of: $1).height(with: parentViewController) - frame.height)
      }) else { return }


      if isTipEnabled == false && closestDestination == .tip {
        move(to: .half)
        return
      }

      move(to: closestDestination)

    default:
      break
    }
  }

  @objc
  private func didPanContentScrollView(_ sender: UIPanGestureRecognizer) {
    guard let scrollView = contentScrollView else { return }

    switch sender.state {
    case .changed:
      /// contentScrollView의 offset.y가 0보다 작을때 contentView의 스크롤이 아닌
      /// bottomSheet를 움직이기 위해서 didPan(_:) 에 sender를 전달해줌.
      /// (현재의 제스쳐를 bottomSheet를 움직이는 데에 사용하겠다는 의미)
      if isContentScrollViewScrolling {
        /// 마지막 contentScrollView의 offset 으로 고정시킨 상태에서 bottomSheet를 움직이기 위한코드
        scrollView.contentOffset.y = capturedContentScrollViewOffsetY

        didPan(sender)
      }

      /// contentScrollView를 더이상 올릴 곳이 없을때 bottomSheet를 움직이게 하기 위한 시작점.
      if scrollView.contentOffset.y <= 0 && isContentScrollViewScrolling == false {
        /// 현재의 sender는 contentScrollView에서 생성된 sender이기 때문에 sender를 그대로 didPan(_:) 으로
        /// 넘기게 되면 offset.y 만큼 차이가 발생해서 bottomSheet의 위치가 순간적으로 offset.y 만큼 이동하게 됨.
        /// 따라서 setTranslation 으로 초기화를 한 번 시켜 줘야함.
        sender.setTranslation(.zero, in: self)

        /// 빠르게 contentScrollView를 올렸을 때 offset.y 가 0 보다 작은 상태에서 contentScrollView를
        /// 잡아서 panning 하게 되면 scrollView가 top으로 즉시 이동하게 됨.
        /// 따라서 스크롤 하던 상태를 고정시킨 후 bottomSheet를 움직이게 하기 위한 로직.
        capturedContentScrollViewOffsetY = scrollView.contentOffset.y

        isContentScrollViewScrolling = true
        return
      }
    case .ended:
      if isContentScrollViewScrolling == true {
        /// bottomSheet를 놓았을 때 offset을 capturedContentScrollViewOffsetY로 지정해주지 않으면
        /// 한 번 offset.y 가 0으로 갔다가 돌아오는 이슈 때문에 아래와 같은 로직 필요함.
        scrollView.contentOffset.y = capturedContentScrollViewOffsetY

        capturedContentScrollViewOffsetY = .zero
        didPan(sender)
      }

      isContentScrollViewScrolling = false
    default:
      break
    }
  }


  // MARK: - Public

  public func configure(parentVC: UIViewController,
                        contentVC: UIViewController) {
    self.parentViewController = parentVC
    self.contentViewController = contentVC
  }

  public func move(to position: BottomSheetPosition) {
    guard let parentViewController else { return }
    contentScrollView?.isScrollEnabled = position == .full

    let topAnchorWithSafeArea: CGFloat = {
      let topAnchor = layout.anchoring(of: position).topAnchor(with: parentViewController)

      switch position {
      case .full:
        let topSafeAreaInset = parentViewController.view.safeAreaInsets.top
        return topAnchor + topSafeAreaInset
      case .half:
        return topAnchor
      case .tip:
        let bottomSafeAreaInset = parentViewController.view.safeAreaInsets.bottom
        return topAnchor + bottomSafeAreaInset
      }
    }()

    topConstraint?.constant = topAnchorWithSafeArea

    UIView.animateWithSpring(
      animation: {
        parentViewController.view.layoutIfNeeded()
      },
      completion: { [weak self] _ in
        self?.delegate?.didMove(to: position)
      })

    delegate?.willMove(to: position)
    currentPosition = position
  }


  // MARK: - Private

  /// Check and configure If contentViewController is/has scrollView
  private func configureContentView(_ contentViewController: UIViewController?) {
    // check and type casting contentViewController is/has scrollView
    guard let contentViewController,
          let parentViewController,
          let contentScrollView = contentViewController.view.firstView(ofType: UIScrollView.self) else { return }
    self.contentScrollView = contentScrollView

    contentScrollView.isScrollEnabled = false
    contentScrollView.panGestureRecognizer.addTarget(self, action: #selector(didPanContentScrollView))

    addSubview(contentViewController.view)
    contentViewController.view.translatesAutoresizingMaskIntoConstraints = false

    /// 정확한 safeArea의 값을 가져오기 위해서 Main thread 에서 constraint 잡음.
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      NSLayoutConstraint.activate([
        contentViewController.view.topAnchor.constraint(equalTo: self.grabberContainerView.bottomAnchor),
        contentViewController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        contentViewController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        contentViewController.view.heightAnchor.constraint(equalToConstant: parentViewController.view.heightWithoutSafeAreas)
      ])
    }
  }

  private func configureBottomSheet(_ parentViewController: UIViewController) {
    parentViewController.view.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false

    topConstraint = topAnchor.constraint(
      equalTo: parentViewController.view.topAnchor,
      constant: layout.anchoring(of: .half).topAnchor(with: parentViewController))

    NSLayoutConstraint.activate([
      topConstraint!,
      leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor),
      trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor),
      bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor),
    ])
  }
}

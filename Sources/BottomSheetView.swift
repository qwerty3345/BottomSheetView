
import UIKit

public protocol BottomSheetViewDelegate {
  func bottomSheetView(_ bottomSheetView: BottomSheetView,
                       willMoveTo destination: BottomSheetPosition,
                       from startPosition: BottomSheetPosition)
  func bottomSheetView(_ bottomSheetView: BottomSheetView,
                       didMoveTo destination: BottomSheetPosition,
                       from startPosition: BottomSheetPosition)
}

// make delegate optioanl by default implementation
extension BottomSheetViewDelegate {
  func bottomSheetView(_ bottomSheetView: BottomSheetView,
                       willMoveTo destination: BottomSheetPosition,
                       from startPosition: BottomSheetPosition) {
  }
  func bottomSheetView(_ bottomSheetView: BottomSheetView,
                       didMoveTo destination: BottomSheetPosition,
                       from startPosition: BottomSheetPosition) {
  }
}

public final class BottomSheetView: UIView {

  // MARK: - Properties

  public var delegate: BottomSheetViewDelegate?

  public var layout = BottomSheetLayout() {
    didSet {
      setupView()
      setupLayout()
    }
  }
  public var appearance = BottomSheetAppearance() {
    didSet {
      setupView()
      setupLayout()
    }
  }
  public var grabberAppearance = BottomSheetGrabberAppearance() {
    didSet {
      setupView()
      setupLayout()
    }
  }

  /// Sets the BottomSheet Position is enabling tip mode.
  /// If set to `false`, only two modes, full and middle, are set
  /// default value is `true`
  public var isTipEnabled: Bool = true

  public private(set) var currentPosition: BottomSheetPosition = .half

  private var isContentScrollViewScrolling = false
  private var capturedContentScrollViewOffsetY: CGFloat = .zero
  private var grabberContainerViewHeightConstraint: NSLayoutConstraint?


  // MARK: - UI

  private weak var parentViewController: UIViewController? {
    willSet {
      guard let parentViewController = newValue else { return }
      configureBottomSheet(parentViewController)
    }
  }
  private weak var contentViewController: UIViewController? {
    willSet {
      DispatchQueue.main.async { [weak self] in
        self?.configureContentView(newValue)
      }
    }
  }
  
  private var safeAreaView: UIView?

  private var topConstraint: NSLayoutConstraint?
  private weak var contentScrollView: UIScrollView?

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
    setupSafeAreaViewLayout()
  }

  private func setupGrabberContainerLayout() {
    addSubview(grabberContainerView)
    grabberContainerView.translatesAutoresizingMaskIntoConstraints = false

    grabberContainerView.constraints.forEach { constraint in
      constraint.isActive = false
    }

    let heightConstraint = grabberContainerView.heightAnchor.constraint(equalToConstant: grabberAppearance.containerHeight)
    NSLayoutConstraint.activate([
      grabberContainerView.topAnchor.constraint(equalTo: topAnchor),
      grabberContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      grabberContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      heightConstraint
    ])
    
    grabberContainerViewHeightConstraint = heightConstraint
  }

  private func setupGrabberLayout() {
    grabberContainerView.addSubview(grabberView)
    grabberView.translatesAutoresizingMaskIntoConstraints = false

    grabberView.constraints.forEach { constraint in
      constraint.isActive = false
    }

    NSLayoutConstraint.activate([
      grabberView.centerXAnchor.constraint(equalTo: grabberContainerView.centerXAnchor),
      grabberView.centerYAnchor.constraint(equalTo: grabberContainerView.centerYAnchor),
      grabberView.widthAnchor.constraint(equalToConstant: grabberAppearance.width),
      grabberView.heightAnchor.constraint(equalToConstant: grabberAppearance.height)
    ])
  }
  
  private func setupSafeAreaViewLayout() {
    if appearance.fillSafeAreaWhenPositionAtFull == false { return }
    if safeAreaView != nil { return }
    guard let parentViewController else { return }
    
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let topSafeAreaSize = parentViewController.view.safeAreaInsets.top
      
      self.safeAreaView = UIView()
      self.safeAreaView?.alpha = 0
      self.safeAreaView?.backgroundColor = .white
      
      parentViewController.view.addSubview(self.safeAreaView!)
      self.safeAreaView?.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        self.safeAreaView!.topAnchor.constraint(equalTo: parentViewController.view.topAnchor),
        self.safeAreaView!.leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor),
        self.safeAreaView!.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor),
        self.safeAreaView!.heightAnchor.constraint(equalToConstant: topSafeAreaSize)
      ])
    }
  }


  // MARK: - Setup Views

  private func setupView() {
    setupBaseView()
    setupShadow()
    setupGrabberView()
  }

  private func setupBaseView() {
    backgroundColor = appearance.backgroundColor

    layer.cornerRadius = appearance.bottomSheetCornerRadius
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  private func setupShadow() {
    layer.shadowOffset = appearance.shadowOffset ?? .zero
    layer.shadowColor = appearance.shadowColor
    layer.shadowPath = appearance.shadowPath
    layer.shadowOpacity = appearance.shadowOpacity ?? .zero
    layer.shadowRadius = appearance.shadowRadius ?? .zero
  }

  private func setupGrabberView() {
    grabberView.backgroundColor = grabberAppearance.backgroundColor
    grabberView.layer.cornerRadius = grabberAppearance.cornerRadius
    NSLayoutConstraint.activate([

    ])
  }


  // MARK: - Setup Gestures

  private func setupGesture() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanBottomSheet))
    addGestureRecognizer(panGestureRecognizer)
  }

  @objc
  private func didPanBottomSheet(_ sender: UIPanGestureRecognizer) {
    guard let parentViewController else { return }

    let translation = sender.translation(in: self)
    let panVelocity = sender.velocity(in: self).y

    switch sender.state {
    case .changed:
      didPanBottomSheetChanged(
        sender,
        parentViewController: parentViewController,
        translation: translation,
        panVelocity: panVelocity)
    case .ended:
      didPanBottomSheetEnded(
        sender,
        parentViewController: parentViewController,
        panVelocity: panVelocity)
    default:
      break
    }
    
    updateSafeAreaViewAppearance()
  }

  private func didPanBottomSheetChanged(_ sender: UIPanGestureRecognizer,
                                        parentViewController: UIViewController,
                                        translation: CGPoint,
                                        panVelocity: CGFloat) {
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
  }

  private func didPanBottomSheetEnded(_ sender: UIPanGestureRecognizer,
                                      parentViewController: UIViewController,
                                      panVelocity: CGFloat) {
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
  }

  @objc
  private func didPanContentScrollView(_ sender: UIPanGestureRecognizer) {
    guard let scrollView = contentScrollView else { return }

    switch sender.state {
    case .changed:
      /// contentScrollView의 offset.y가 0보다 작을때 contentView의 스크롤이 아닌
      /// bottomSheet를 움직이기 위해서 didPanBottomSheet(_:) 에 sender를 전달해줌.
      /// (현재의 제스쳐를 bottomSheet를 움직이는 데에 사용하겠다는 의미)
      if isContentScrollViewScrolling {
        /// 마지막 contentScrollView의 offset 으로 고정시킨 상태에서 bottomSheet를 움직이기 위한코드
        if appearance.isContentScrollViewBouncingWhenScrollDown {
          scrollView.contentOffset.y = capturedContentScrollViewOffsetY
        } else {
          scrollView.contentOffset.y = 0
        }

        didPanBottomSheet(sender)
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
        didPanBottomSheet(sender)
      }

      isContentScrollViewScrolling = false
    default:
      break
    }
  }
  
  private func updateSafeAreaViewAppearance() {
    if appearance.fillSafeAreaWhenPositionAtFull == false { return }
    guard let parentViewController else { return }
    
    let threshold: CGFloat = 44
    let topSafeAreaSize = parentViewController.view.safeAreaInsets.top
    
    let multiplier = 1 - (frame.minY - topSafeAreaSize) / (topSafeAreaSize + threshold)
    if multiplier >= 0 && multiplier <= 1 {
      // Update corner radius
      let cornerRadius = appearance.bottomSheetCornerRadius * (1 - multiplier)
      layer.cornerRadius = cornerRadius
      safeAreaView?.alpha = multiplier
      
      // Update bottomSheet shadow
      let shadowAlpha = 1 - multiplier
      layer.shadowOpacity = Float(shadowAlpha)
      
      // Update grabber view height
      grabberContainerViewHeightConstraint?.constant = grabberAppearance.containerHeight * (1 - multiplier)
      grabberView.setNeedsLayout()
      
      // Update grabber view alpha
      grabberContainerView.alpha = (1 - multiplier)
    }
  }
  
  private func updateSafeAreaView(_ position: BottomSheetPosition) {
    if appearance.fillSafeAreaWhenPositionAtFull == false { return }
    
    switch position {
    case .full:
      showSafeAreaView()
    case .half:
      hideSafeAreaView()
    case .tip:
      hideSafeAreaView()
    }
  }
  
  private func showSafeAreaView() {
    if appearance.fillSafeAreaWhenPositionAtFull == false { return }
    let animationDuration: CGFloat = 0.3
    UIView.animate(withDuration: animationDuration) {
      self.safeAreaView?.alpha = 1
      self.layer.cornerRadius = 0
      self.layer.shadowOpacity = 0
    }
    
    // Update grabber view
    grabberContainerViewHeightConstraint?.constant = 0
    UIView.animate(withDuration: animationDuration) {
      self.grabberContainerView.alpha = 0
      self.grabberContainerView.layoutIfNeeded()
    }
  }
  
  private func hideSafeAreaView() {
    if appearance.fillSafeAreaWhenPositionAtFull == false { return }
    let animationDuration: CGFloat = 0.3
    
    UIView.animate(withDuration: animationDuration) {
      self.safeAreaView?.alpha = 0
      self.layer.cornerRadius = self.appearance.bottomSheetCornerRadius
      self.layer.shadowOpacity = self.appearance.shadowOpacity ?? .zero
    }
    
    // Update grabber view
    grabberContainerViewHeightConstraint?.constant = grabberAppearance.containerHeight
    UIView.animate(withDuration: animationDuration) {
      self.grabberContainerView.alpha = 1
      self.grabberContainerView.layoutIfNeeded()
    }
    
    contentScrollView?.scrollToTop()
  }
  

  // MARK: - Public

  public func configure(parentViewController: UIViewController,
                        contentViewController: UIViewController) {
    removeContentViewController()
    
    self.parentViewController = parentViewController
    self.contentViewController = contentViewController
  }
  
  public func removeContentViewController() {
    guard let oldContentVC = self.contentViewController else { return }
    
    removeSubviews()
    oldContentVC.view.removeSubviews()
    
    contentScrollView?.gestureRecognizers?.forEach {
      contentScrollView?.removeGestureRecognizer($0)
    }
    
    self.parentViewController = nil
    self.contentScrollView = nil
    self.contentViewController = nil
  }

  public func move(to position: BottomSheetPosition) {
    let startPosition = currentPosition
    guard let parentViewController else { return }
    contentScrollView?.isScrollEnabled = position == .full
    updateSafeAreaView(position)

    let topAnchorWithSafeArea: CGFloat = {
      let topAnchor = layout.anchoring(of: position).topAnchor(with: parentViewController)

      switch position {
      case .full:
        let topSafeAreaInset = appearance.ignoreSafeArea.contains(.top) ? 0 : parentViewController.view.safeAreaInsets.top
        return topAnchor + topSafeAreaInset
      case .half:
        return topAnchor
      case .tip:
        let bottomSafeAreaInset = appearance.ignoreSafeArea.contains(.bottom) ? 0 : parentViewController.view.safeAreaInsets.bottom
        return topAnchor - bottomSafeAreaInset - grabberAppearance.containerHeight
      }
    }()

    topConstraint?.constant = topAnchorWithSafeArea

    UIView.animateWithSpring(
      animation: {
        parentViewController.view.layoutIfNeeded()
      },
      completion: { [weak self] _ in
        guard let self,
              let delegate else { return }
        delegate.bottomSheetView(self, didMoveTo: position, from: startPosition)
      })

    if let delegate {
      delegate.bottomSheetView(self, willMoveTo: position, from: startPosition)
    }
    
    currentPosition = position
  }
  
  /// this method moves bottomSheetView to certain position by `BottonSheetAnchoring` like fractional, absolute position
  ///
  /// ** ALERT: This method does not account for the safe area. **
  public func move(to anchor: BottomSheetAnchoring) {
    guard let parentViewController else { return }
    
    let topAnchor = anchor.topAnchor(with: parentViewController)
    topConstraint?.constant = topAnchor
    
    UIView.animateWithSpring(
      animation: {
        parentViewController.view.layoutIfNeeded()
      }
    )
  }
  
  public func show(_ position: BottomSheetPosition? = nil) {
    if let position = position {
      move(to: position)
    } else {
      move(to: currentPosition)
    }
  }
  
  public func hide() {
    guard let parentViewController,
          let topConstraint else { return }
    topConstraint.constant = parentViewController.view.frame.height
    UIView.animateWithSpring(
      animation: {
        parentViewController.view.layoutIfNeeded()
      }
    )
    
    hideSafeAreaView()
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

    NSLayoutConstraint.activate([
      contentViewController.view.topAnchor.constraint(equalTo: grabberContainerView.bottomAnchor),
      contentViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentViewController.view.heightAnchor.constraint(equalToConstant: parentViewController.view.heightWithoutSafeAreas)
    ])
  }

  private func configureBottomSheet(_ parentViewController: UIViewController) {
    parentViewController.view.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false

    topConstraint = topAnchor.constraint(
      equalTo: parentViewController.view.topAnchor,
      constant: layout.anchoring(of: .half).topAnchor(with: parentViewController)
    )

    guard let topConstraint else { return }

    NSLayoutConstraint.activate([
      topConstraint,
      leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor),
      trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor),
      bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor),
    ])
  }
}

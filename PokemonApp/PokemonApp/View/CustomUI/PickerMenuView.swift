//
//  PickerMenuView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import UIKit

class PickerMenuView<T: CaseIterable>: UIView where T: ImageRepresentable, T: ColorRepresentable, T: TextRepresentable{
    
    let stackViewCellHeight: CGFloat = 30
    let stackViewSpacing: CGFloat = 15
    
    enum HorizontalPosition {
        case left
        case right
    }
    
    enum VerticalPosition {
        case top
        case bottom
    }
    
    enum ShowDirection {
        case scrollUp
        case scrollDown
    }
    
    private var containerXConstraint: NSLayoutConstraint?
    private var containerYConstraint: NSLayoutConstraint?
    private var containerWidth: NSLayoutConstraint?
    private var containerHeight: NSLayoutConstraint?
    
    private var contentTopConstraint: NSLayoutConstraint?
    private var contentBottomConstraint: NSLayoutConstraint?
    private var contentHeight: NSLayoutConstraint?
    
    private var stackViewHeight: CGFloat {
        return CGFloat(T.allCases.count) * stackViewCellHeight + stackViewSpacing * CGFloat(T.allCases.count - 1)
    }
    
    private var buttons: [EnumTappableButton<T>] = {
        var toRet = [EnumTappableButton<T>]()
        for i in T.allCases {
            var v = EnumTappableButton<T>()
            v.config(type: i, isEnabled: true)
            toRet.append(v)
        }
        return toRet
    }()
    
    private var showDirection: ShowDirection = .scrollUp
    
    public var selectedType: (T) -> () = {_ in }
    
    public var checkValidity: ((T) -> Bool)? {
        didSet{
            guard let check = checkValidity else { return }
            for button in buttons {
                button.isEnabled = check(button.type)
            }
        }
    }
    
    private var contentView: UIView = {
        
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .clear
        self.addSubview(background)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(outsideTapped))
        background.addGestureRecognizer(tap)
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.bringSubviewToFront(background)
        containerXConstraint = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        containerYConstraint = view.topAnchor.constraint(equalTo: self.topAnchor)
        containerWidth = view.widthAnchor.constraint(equalToConstant: 20)
        containerHeight = view.heightAnchor.constraint(equalToConstant: 20)
        
        containerXConstraint?.isActive = true
        containerYConstraint?.isActive = true
        containerWidth?.isActive = true
        containerHeight?.isActive = true
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        self.addSubview(contentView)
        
        contentTopConstraint = contentView.topAnchor.constraint(equalTo: view.topAnchor)
        contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentHeight = contentView.heightAnchor.constraint(equalToConstant: 0)
        
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.alignment = .fill
        stackView.spacing = stackViewSpacing
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 15).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        
        
        for view in buttons {
            view.selectedType = {[weak self] type in
                guard let self = self else { return }
                self.dismissView()
                self.selectedType(type)
            }
            view.isUserInteractionEnabled = true
            stackView.addArrangedSubview(view)
        }
    }
    
    @objc func outsideTapped() {
        animateDisappear()
    }
    
    public func animateAppear() {
        contentHeight?.constant = stackViewHeight + 30
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.layoutIfNeeded()
        })
    }
    
    public func animateDisappear() {
        contentHeight?.constant = 0
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.layoutIfNeeded()
        }, completion: {[weak self] _ in
            guard let self = self else  { return }
            self.dismissView()
        })
        
    }
    
    private func config(configuration: PickerMenuViewConfiguration, containerFrame: CGRect, direction: ShowDirection) {
        
        containerXConstraint?.constant = containerFrame.minX
        containerYConstraint?.constant = containerFrame.minY
        containerWidth?.constant = containerFrame.width
        containerHeight?.constant = containerFrame.height
        
        switch direction {
        case .scrollUp:
            contentBottomConstraint?.isActive = true
            contentHeight?.isActive = true
            contentTopConstraint?.isActive = false
        case .scrollDown:
            contentBottomConstraint?.isActive = false
            contentHeight?.isActive = true
            contentTopConstraint?.isActive = true
        }
        
        self.layoutIfNeeded()
        animateAppear()
    }
    
    
    
    static func showPicker(view: UIView, configuration: PickerMenuViewConfiguration, onItemSelected: @escaping (T) -> (), checkValidity: @escaping (T) -> Bool){
        
        let globalPoint = view.superview?.convert(view.frame.origin, to: nil)
        let totalWidth = Utils.shared.getWindowSize().width
        let totalHeight = Utils.shared.getWindowSize().height
        guard let global = globalPoint else { return }
        let globalCenter = CGPoint(x: global.x + view.bounds.width / 2, y: global.y + view.bounds.height / 2)
        
        let horizontal: HorizontalPosition = globalCenter.x > totalWidth/2 ? .left : .right
        let vertical: VerticalPosition = globalCenter.y > totalHeight/2 ? .top : .bottom
        
        let frame = PickerMenuView.computeFrameForView(view: view, horizontalPosition: horizontal, verticalPosition: vertical, configuration: configuration)
        
        let window = UIApplication.shared.keyWindow!
        let v = PickerMenuView(frame: window.bounds)
        window.addSubview(v)
        v.config(configuration: configuration, containerFrame: frame, direction: vertical == .top ? .scrollUp : .scrollDown)
        v.selectedType = onItemSelected
        v.checkValidity = checkValidity
    }
    
    private func dismissView() {
        self.removeFromSuperview()
    }
    
    private static func computeFrameForView(view: UIView, horizontalPosition: HorizontalPosition, verticalPosition: VerticalPosition, configuration: PickerMenuViewConfiguration) -> CGRect {
        
        var width: CGFloat = 0
        var xPos: CGFloat
        
        var height: CGFloat = 0
        var yPos: CGFloat = 0
        
        let globalPoint = view.superview?.convert(view.frame.origin, to: nil)
        let totalWidth = Utils.shared.getWindowSize().width
        let totalHeight = Utils.shared.getWindowSize().height
        let globalCenter = CGPoint(x: globalPoint!.x + view.bounds.width / 2, y: globalPoint!.y + view.bounds.height / 2)
        
        
        switch horizontalPosition {
        case .left:
            width = min(configuration.maxWidth, globalCenter.x - view.bounds.width/2 - configuration.paddingFromView - 15)
            xPos = globalCenter.x - view.bounds.width/2 - configuration.paddingFromView - width
        case .right:
            width = min(configuration.maxWidth, totalWidth - (globalCenter.x + view.bounds.width/2 + configuration.paddingFromView + 15))
            xPos = globalCenter.x + view.bounds.width/2 + configuration.paddingFromView
        }
        
        switch verticalPosition {
        case .top:
            height = globalCenter.y + view.bounds.height - 20
            yPos = 20
        case .bottom:
            height = totalHeight - globalCenter.y - view.bounds.height/2
            yPos = globalCenter.y - view.bounds.height/2
        }
        
        return CGRect(x: xPos, y: yPos, width: width, height: height)
    }

}

struct PickerMenuViewConfiguration {
    
    let maxWidth: CGFloat
    let paddingFromView: CGFloat
    
    init(maxWidth: CGFloat = 150, paddingFromView: CGFloat = 20) {
        self.maxWidth = maxWidth
        self.paddingFromView = paddingFromView
    }
    
}

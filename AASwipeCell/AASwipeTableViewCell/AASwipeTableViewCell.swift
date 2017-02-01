//
//  AASwipeTableViewCell.swift
//  TrackMe
//
//  Created by Aleksandar Atanackovic on 1/31/17.
//  Copyright © 2017 Plava Tvornica. All rights reserved.
//

import UIKit

enum Type {
    case ´default´
    case trail
    case slide
}

class AASwipeTableViewCell: UITableViewCell {
    
    //tracking start location for calculating moved distance of touch
    fileprivate var startOriginX:CGFloat = 0
    
    //custom content insets for contentView
    var contentViewInset:UIEdgeInsets = .zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    //type of animation
    var type:Type = .´default´ {
        didSet {
            self.configureButtonsLayout()
        }
    }
    
    //custom content insets for buttonsContainer
    var buttonsContainerViewInset:UIEdgeInsets = .zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    //array of buttons that will be rendered and set with superView under contentView
    fileprivate var buttons:[UIView] = [] {
        didSet {
            let _ = self.buttons.map{self.buttonsContainerView.addSubview($0)}
        }
    }
    
    fileprivate var startButtonViewPosition:CGFloat = 0
    
    //superView for buttons
    var buttonsContainerView:UIView = UIView(frame: .zero)
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureCell()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    fileprivate func configureCell() {
        self.configureSwipe()
        
        self.insertSubview(self.buttonsContainerView, belowSubview: self.contentView)
        //set subViews in to be cliped as contanerView(round corners..)
        self.buttonsContainerView.clipsToBounds = true
        //hardcoded because of contentView selecting color color
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //removing buttons to prepare clean view for new ones
        let _ = self.buttons.map{$0.removeFromSuperview()}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set contentView frame with custom insets
        self.contentView.frame = CGRect(x: self.contentViewInset.left, y: self.contentViewInset.top, width: self.frame.size.width - self.contentViewInset.left - self.contentViewInset.right, height: self.frame.size.height - self.contentViewInset.top - self.contentViewInset.bottom)
        guard self.buttons.count > 0 else {
            return
        }
        
        self.configureButtonsLayout()
    }
    
    func setButtons(with array:[UIButton]) {
        self.buttons = array
        
    }
    
    
    private func configureButtonsLayout() {
        
        var buttonSize = self.contentView.frame.size.height
        var buttonViewWidth = CGFloat(self.buttons.count) * buttonSize
        
        //if cell height is to big buttons will stretch out of bounds and will be wider than contentView width
        //this 'if' statement prevents that with resizing buttons
        if buttonViewWidth > self.contentView.frame.size.width || buttonSize > self.contentView.frame.size.width / 3  {
            buttonSize = self.contentView.frame.size.width / CGFloat(self.buttons.count) / 1.8
            buttonViewWidth = CGFloat(self.buttons.count) * buttonSize
            
        }
        
        //´default´ type sets buttons containerView in fixed under the containerView
        self.startButtonViewPosition = self.frame.width - (self.type == .´default´ ? buttonViewWidth : 0) - self.buttonsContainerViewInset.right
        
        self.buttonsContainerView.frame = CGRect(x: self.startButtonViewPosition, y: self.buttonsContainerViewInset.top, width: buttonViewWidth, height: self.frame.size.height - self.buttonsContainerViewInset.top - self.buttonsContainerViewInset.bottom)
        
        if self.type == .slide {
            let _ = self.buttons.reversed().map{
                $0.frame = CGRect(x: 0, y: 0, width: buttonSize, height: self.buttonsContainerView.frame.height)
            }
        } else {
            for (i, button) in self.buttons.enumerated() {
                button.frame = CGRect(x: CGFloat(i) * buttonSize, y: 0, width: buttonSize, height: self.buttonsContainerView.frame.height)
            }
        }
        
    }
    
    private func setTrailButtonsPosition() {
        self.buttonsContainerView.frame.origin.x = self.contentView.frame.origin.x + self.contentView.frame.size.width
    }
    
    private func setSlidingButtonsPosition() {
        self.setTrailButtonsPosition()
        let movedPercentage = (self.startButtonViewPosition - self.buttonsContainerView.frame.origin.x) / self.buttonsContainerView.frame.size.width
        
        for (i, button) in self.buttons.enumerated() {
            let buttonPosition = CGFloat(i) * button.frame.size.width
            button.frame.origin.x = buttonPosition * movedPercentage
        }
        
    }
    
    //MARK: Handle swipe
    
    private func configureSwipe() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.delegate = self
        self.contentView.addGestureRecognizer(panGesture)
        
    }
    
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        guard self.buttons.count > 0 else {
            return
        }
        
        let location = gesture.location(in: self.contentView)
        
        switch gesture.state {
        case .began:
            self.panBegan(location: location)
        case .changed:
            self.panMoved(location: location, gestureRecognizer:gesture)
        case .cancelled, .ended, .failed:
            self.panEnded(gestureRecognizer:gesture)
        default:
            self.panEnded(gestureRecognizer:gesture)
        }
        
        
    }
    
    private func panBegan(location:CGPoint) {
        self.startOriginX = location.x + self.contentViewInset.left
        
    }
    
    private func panMoved(location:CGPoint, gestureRecognizer:UIPanGestureRecognizer) {
        //check if table isScrolled to prevent scrolling tableView and swiping cell
        guard let table = self.superview?.superview as? UITableView, !table.isDragging  else {
            return
        }
        table.isScrollEnabled = false
        
        let movedDistance = location.x - self.startOriginX
        let swipedViewLocation = self.contentView.frame.origin.x + movedDistance
        
        switch swipedViewLocation{
        case let value where value >= 0:
            self.contentView.frame.origin.x = self.contentViewInset.left
        case let value where value < -self.buttonsContainerView.frame.size.width:
            self.contentView.frame.origin.x = -self.buttonsContainerView.frame.size.width
        default:
            self.contentView.frame.origin.x += movedDistance
        }
        
        if self.type == .trail {
            self.setTrailButtonsPosition()
        } else if self.type == .slide {
            self.setSlidingButtonsPosition()
        }
        
        self.updateConstraintsIfNeeded()
        
    }
    
    private func panEnded(gestureRecognizer:UIPanGestureRecognizer) {
        //calculate if last position is near left or right side
        guard let table = self.superview?.superview as? UITableView, !table.isDragging  else {
            return
        }
        table.isScrollEnabled = true
        
        let velocity = gestureRecognizer.velocity(in: self.contentView)
        
        var isCellSwipped = self.contentView.frame.origin.x < -buttonsContainerView.frame.size.width / 2
        if velocity.x > self.frame.size.width {
            isCellSwipped = false
        } else if velocity.x < -self.frame.size.width {
            isCellSwipped = true
        }
        
        self.animate(toLeft: isCellSwipped)
        
        self.startOriginX = 0
        
    }
    
    
    private func animate(toLeft:Bool) {
        
        var customBackgroundPosition:CGFloat = self.contentViewInset.left
        
        if toLeft {
            customBackgroundPosition = -self.buttonsContainerView.frame.width
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            self.contentView.frame.origin.x = customBackgroundPosition
            if self.type == .trail {
                self.setTrailButtonsPosition()
            } else if self.type == .slide {
                self.setSlidingButtonsPosition()
            }
            
            self.updateConstraintsIfNeeded()
        }, completion: nil)
        
        
    }
    
    
}



//
//  AASwipeTableViewCell.swift
//  TrackMe
//
//  Created by Aleksandar Atanackovic on 1/31/17.
//  Copyright © 2017 Plava Tvornica. All rights reserved.
//

import UIKit

class AASwipeTableViewCell: UITableViewCell {
    
    //tracking start location for calculating moved distance of touch
    fileprivate var startOriginX:CGFloat = 0
    
    //tracking location of last touch to prevent swiping cell and tableView scrolling in same time
    fileprivate var oldTouchPoint = CGPoint(x: 0, y: 0)
    
    
    //custom content insets for contentView
    var contentViewInset:UIEdgeInsets = .zero {
        didSet {
            self.layoutSubviews()
        }
    }
    //custom content insets for buttonsContainer
    var buttonsContainerViewInset:UIEdgeInsets = .zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    //array of buttons that will be rendered and set with superView under contentView
    fileprivate var buttons:[UIButton] = [] {
        didSet {
            let _ = self.buttons.map{self.buttonsContainerView.addSubview($0)}
        }
    }
    
    //superView for buttons
    var buttonsContainerView:UIView = UIView(frame: .zero)
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.insertSubview(self.buttonsContainerView, belowSubview: self.contentView)
        //set subViews in to be cliped as contanerView(round corners..)
        self.buttonsContainerView.clipsToBounds = true
        //hardcoded because of contentView selecting color color
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
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
            buttonSize = self.contentView.frame.size.width / CGFloat(self.buttons.count) / 2
            buttonViewWidth = CGFloat(self.buttons.count) * buttonSize
            
        }
        
        self.buttonsContainerView.frame = CGRect(x: self.frame.width - buttonViewWidth - self.buttonsContainerViewInset.right, y: self.buttonsContainerViewInset.top, width: buttonViewWidth, height: self.frame.size.height - self.buttonsContainerViewInset.top - self.buttonsContainerViewInset.bottom)
        for (i, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(i) * buttonSize, y: 0, width: buttonSize, height: self.buttonsContainerView.frame.height)
        }
    }
    

}

extension AASwipeTableViewCell {
    
    func configureSwipe() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.delegate = self
        self.contentView.addGestureRecognizer(panGesture)
        
    }

    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handlePan(gesture:UIPanGestureRecognizer) {
        guard self.buttons.count > 0 else {
            return
        }
        
        let location = gesture.location(in: self.contentView)
        
        switch gesture.state {
        case .began:
            self.panBegan(location: location)
        case .changed:
            self.panMoved(location: location)
        case .cancelled, .ended, .failed:
            self.panEnded()
        default:
            self.panEnded()
        }
        
        
    }
    
    private func panBegan(location:CGPoint) {
        self.startOriginX = location.x + self.contentViewInset.left
        self.oldTouchPoint = location
    
    }

    private func panMoved(location:CGPoint) {
        //check if table isScrolled to prevent scrolling tableView and swiping cell
        guard let table = self.superview?.superview as? UITableView, !table.isDragging  else {
            return
        }
        //check if location is scrolled to top/bottom or left right
        if abs(oldTouchPoint.x - location.x) <= abs(oldTouchPoint.y - location.y) {
            return
        }
        
        self.oldTouchPoint = location
        
        let movedDistance = location.x - self.startOriginX
        let swipedViewLocation = self.contentView.frame.origin.x + movedDistance
        
        switch swipedViewLocation{
        case let value where value >= 0:
            self.contentView.frame.origin.x = self.contentViewInset.left
        case let value where value < -buttonsContainerView.frame.size.width:
            self.contentView.frame.origin.x = -buttonsContainerView.frame.size.width
        default:
            self.contentView.frame.origin.x += movedDistance
            self.updateConstraintsIfNeeded()
        }
        
    }
    
    private func panEnded() {
        //calculate if last position is near left or right side
        let isCellSwipped = self.contentView.frame.origin.x < -buttonsContainerView.frame.size.width / 2
        self.animate(toLeft: isCellSwipped)

        self.startOriginX = 0
        
    }
    
    
    func animate(toLeft:Bool) {
        
        var customBackgroundPosition:CGFloat = self.contentViewInset.left
        
        if toLeft {
            customBackgroundPosition = -self.buttonsContainerView.frame.width
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            self.contentView.frame.origin.x = customBackgroundPosition
            self.updateConstraintsIfNeeded()
        }, completion: nil)
        
        
    }
    
    
}


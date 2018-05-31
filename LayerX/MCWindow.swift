//
//  MCWindow.swift
//  LayerX
//
//  Created by Michael Chen on 2015/10/27.
//  Copyright © 2015年 Michael Chen. All rights reserved.
//

import Cocoa

class MCWIndow: NSWindow {
	override func awakeFromNib() {
		styleMask = [.borderless, .resizable]
		isOpaque = false
		backgroundColor = NSColor.clear
		isMovableByWindowBackground = true
		hasShadow = false
	}

    func moveBy(_ offset: CGPoint) {
        var frame = self.frame
        frame.origin.x += offset.x
        frame.origin.y += offset.y

        setFrame(frame, display: true)
    }

	func fitsWithSize(_ size: NSSize) {
        
        guard let screenFrame = screen?.frame else {
            return
        }
 
		var frame = self.frame
        
        var intersection = screenFrame.intersection(frame)
        
        if intersection.height != frame.height || intersection.width != frame.width {
            frame.size = size
            intersection = screenFrame.intersection(frame)
    
        }

        if intersection.height != frame.height {
            if frame.minY < screenFrame.minY {
                frame.origin.y += frame.height - intersection.height
            } else if frame.maxY > screenFrame.maxY {
                frame.origin.y -= frame.height - intersection.height
            }
        }
        
        if intersection.width != frame.width {
            if frame.minX < screenFrame.minX {
                frame.origin.x += frame.width - intersection.width
            }  else if frame.maxX > screenFrame.maxX {
                frame.origin.x -= frame.width - intersection.width
            }
        }

        setFrame(frame, display: true)
	}

	func resizeTo(_ size: NSSize, animated: Bool) {

        let frame = self.frame.insetBy(
            dx: (self.frame.width - size.width) / 2,
            dy: (self.frame.height - size.height) / 2)

		if !animated {
			setFrame(frame, display: true)
			return
		}

		let resizeAnimation = [NSViewAnimation.Key.target: self, NSViewAnimation.Key.endFrame: NSValue(rect: frame)]
		let animations = NSViewAnimation(viewAnimations: [resizeAnimation])
		animations.animationBlockingMode = .blocking
		animations.animationCurve = .easeInOut
		animations.duration = 0.15
		animations.start()
	}

    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        return frameRect
    }
}

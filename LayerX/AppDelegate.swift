//
//  AppDelegate.swift
//  LayerX
//
//  Created by Michael Chen on 2015/10/26.
//  Copyright © 2015年 Michael Chen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var scale: CGFloat = 1 {
        didSet {
            if scale < 0.1 {
                scale = 0.1
            }
            let image = viewController.imageView.image!
            let size = image.size * scale
            window.resizeTo(size, animated: true)
        }
    }

	weak var window: MCWIndow!
	weak var viewController: ViewController!
    var isLockIconHiddenWhileLocked = false {
        didSet { viewController.lockIconImageView.isHidden = window.isMovable || isLockIconHiddenWhileLocked }
    }

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let window = NSApp.windows.first as? MCWIndow {
            window.level = .mainMenu + 1;
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                window.fitsWithSize(NSMakeSize(480, 320))
            }
			self.window = window
		}
	}
}

fileprivate enum ArrowTag: Int {
    case up = 20
    case left = 21
    case right = 22
    case down = 23
}

// MARK: - Hotkeys

extension AppDelegate {

	@IBAction func actualSize(_ sender: AnyObject?) {
		scale = 1
	}
    
    @IBAction func retina2x(_ sender: AnyObject?) {
        scale = 0.5
    }
    
    @IBAction func retina3x(_ sender: AnyObject?) {
        scale = 1 / 3
    }

	@IBAction func makeLarger(_ sender: AnyObject) {
		scale += 0.1
	}

	@IBAction func makeSmaller(_ sender: AnyObject) {
		scale -= 0.1
	}

	@IBAction func makeLargerOnePixel(_ sender: AnyObject) {
		var size = window.frame.size
		size.width += 1
		size.height += 1
		window.resizeTo(size, animated: true)
	}

	@IBAction func makeSmallerOnePixel(_ sender: AnyObject) {
		var size = window.frame.size
		size.width -= 1
		size.height -= 1
		window.resizeTo(size, animated: true)
	}

	@IBAction func increaseTransparency(_ sender: AnyObject) {
		let alpha = viewController.imageView.alphaValue - 0.1
		viewController.imageView.alphaValue = max(alpha, 0.05)
	}

	@IBAction func reduceTransparency(_ sender: AnyObject) {
		let alpha = viewController.imageView.alphaValue + 0.1
		viewController.imageView.alphaValue = min(alpha, 1.0)
	}
	
	@IBAction func toggleLockWindow(_ sender: AnyObject) {
		let menuItem = sender as! NSMenuItem
		if menuItem.title == "Lock" {
			menuItem.title  = "Unlock"
			window.isMovable = false
			window.ignoresMouseEvents = true
		} else {
			menuItem.title  = "Lock"
			window.isMovable = true
			window.ignoresMouseEvents = false

		}

		viewController.lockIconImageView.isHidden = window.isMovable || isLockIconHiddenWhileLocked
	}
    
    @IBAction func toggleLockIconVisibility(_ sender: AnyObject) {
        let menuItem = sender as! NSMenuItem
        menuItem.state = menuItem.state == .on ? .off : .on
        isLockIconHiddenWhileLocked = menuItem.state == .on
    }

    @IBAction func moveAround(_ sender: AnyObject) {
        let menuItem = sender as! NSMenuItem

        guard let arrow = ArrowTag(rawValue: menuItem.tag) else {
            return
        }

        switch arrow {
        case .up:
            window.moveBy(CGPoint(x: 0, y: 1))
        case .left:
            window.moveBy(CGPoint(x: -1, y: 0))
        case .right:
            window.moveBy(CGPoint(x: 1, y: 0))
        case .down:
            window.moveBy(CGPoint(x: 0, y: -1))
        }
    }

	override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		return viewController.imageView.image != nil
	}
}

// MARK: - Helper

func appDelegate() -> AppDelegate {
	return NSApp.delegate as! AppDelegate
}

func *(size: NSSize, scale: CGFloat) -> NSSize {
	return NSMakeSize(size.width * scale, size.height * scale)
}

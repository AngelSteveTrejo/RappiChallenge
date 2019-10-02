//
//  RappiSplashView.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

typealias SplashAnimatableCompletion = () -> Void
typealias SplashAnimatableExecution = () -> Void

enum SplashAnimationType: String {
    case rappi
}

/// Protocol that represents splash animatable functionality
protocol SplashAnimatable: class {
    /// The image view that shows the icon
    var iconSplashImageView: UIImageView? { get set }
    /// The animation type.
    var animationType: SplashAnimationType { get set }
    /// The duration of the overall animation
    var duration: Double { get set }
    /// The delay to play the animation
    var delay: Double { get set }
}


/// SplashView that reveals its content and animate.
final class RappiSplashView: UIView, SplashAnimatable {
    /// The icon image to show and reveal with
    var iconImage: UIImage? {
        didSet{
            if let iconImage = self.iconImage{
                iconSplashImageView?.image = iconImage
            }
        }
    }
    /// The icon color of the image, defaults is white
    var iconColor: UIColor = UIColor.white {
        didSet {
            iconSplashImageView?.tintColor = .mustard
        }
    }
    /// The initial size of the icon. Ideally it has to match with the size of the icon in your LaunchScreen Splash view
    var iconInitialSize: CGSize = CGSize(width: 60, height: 60) {
        didSet {
            iconSplashImageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        }
    }
    /// Tee image view containing the icon Image
    var iconSplashImageView: UIImageView?
    /// The type of animation to use for the. Defaults to the twitter default animation
    var animationType: SplashAnimationType = SplashAnimationType.rappi
    /// The duration of the animation, default to 1.5 seconds. 
    var duration: Double = 1.5
    /// The delay of the animation, default to 0.5 seconds
    var delay: Double = 0.5
    
    /// Default constructor of the class
    ///
    /// - Parameters:
    ///   - iconImage: The Icon image to show the animation
    ///   - iconInitialSize: The initial size of the icon image
    ///   - backgroundColor: The background color of the image, ideally this should match your Splash view.
    init(iconImage: UIImage, iconInitialSize: CGSize, backgroundColor: UIColor) {
        //Sets the initial values of the image view and icon view
        self.iconSplashImageView = UIImageView()
        self.iconImage = iconImage
        self.iconInitialSize = iconInitialSize
        //Inits the view to the size of the screen
        super.init(frame: (UIScreen.main.bounds))
        iconSplashImageView?.image = iconImage
        iconSplashImageView?.tintColor = iconColor
        //Set the initial size and position
        iconSplashImageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        //Sets the content mode and set it to be centered
        iconSplashImageView?.contentMode = UIView.ContentMode.scaleAspectFit
        iconSplashImageView?.center = self.center
        //Adds the icon to the view
        if let imageView = iconSplashImageView {
            self.addSubview(imageView)
        }
        //Sets the background color
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Class extension to define the basic functionality for the RevealingSplashView class
extension RappiSplashView {
    /// Starts the animation depending on the type
    ///
    /// - Parameter completion: SplashAnimatableCompletion
    func startAnimation(_ completion: SplashAnimatableCompletion? = nil) {
        switch animationType {
        case .rappi:
            playTwitterAnimation(completion)
        }
    }
    
    /// Plays the twitter animation
    ///
    /// - Parameter completion: SplashAnimatableCompletion
    private func playTwitterAnimation(_ completion: SplashAnimatableCompletion? = nil) {
        if let imageView = self.iconSplashImageView {
            //Define the shink and grow duration based on the duration parameter
            let shrinkDuration: TimeInterval = duration * 0.3
            //Plays the shrink animation
            UIView.animate(withDuration: shrinkDuration,
                           delay: delay, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(),
                           animations: {
                //Shrinks the image
                let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.75,y: 0.75)
                imageView.transform = scaleTransform
                //When animation completes, grow the image
                }, completion: { [weak self] finished in
                    guard let self = self else { return }
                    self.playZoomOutAnimation(completion)
            })
        }
    }
    
    /// Plays the zoom out animation with completion
    ///
    /// - Parameter completion: SplashAnimatableCompletion
    private func playZoomOutAnimation(_ completion: SplashAnimatableCompletion? = nil) {
        if let imageView =  iconSplashImageView
        {
            let growDuration: TimeInterval =  duration * 0.3
            UIView.animate(withDuration: growDuration,
                           animations: {
                imageView.transform = self.getZoomOutTranform()
                self.alpha = 0
                //When animation completes remote self from super view
            }, completion: { finished in
                self.removeFromSuperview()
                completion?()
            })
        }
    }
    
    /// Retuns the default zoom out transform to be use mixed with other transform
    ///
    /// - Returns: ZoomOut fransfork
    private func getZoomOutTranform() -> CGAffineTransform {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
        return zoomOutTranform
    }

    private func animateLayer(_ animation: SplashAnimatableExecution,
                              completion: SplashAnimatableCompletion? = nil) {
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock { completion() }
        }
        animation()
        CATransaction.commit()
    }
}

//
//  ViewController.swift
//  iService
//
//  Created by Abhishek Dwivedi on 17/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }

    //Sets up backgroud video background
    func setupView() {
        
        let path = NSURL(fileURLWithPath:
            NSBundle.mainBundle().pathForResource("bg-video", ofType: "mp4")!)
        let player = AVPlayer(URL: path)
        
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = backgroundView.frame
        
        self.backgroundView.layer.addSublayer(newLayer)
        
        newLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.appTitleCenter(self.backgroundView)
        
        player.play()
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            "videoDidPlayToEnd:", name: "AVPlayerItemDidPlayToEndTimeNotification",
                    object: player.currentItem)
        
        self.createButtons(self.backgroundView)
    }
    
    //Loops the video
    func videoDidPlayToEnd(notification: NSNotification) {
        
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seekToTime(kCMTimeZero)
    }
    
    //Sets up App title, iService in the center
    func appTitleCenter(containerView: UIView) {
        
        let half: CGFloat = 1.0/2.0
        let titleLabel = UILabel()
        titleLabel.text = "iService"
        titleLabel.font = UIFont(name: "Apple Color Emoji", size: 50.0)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.frame.origin.x = (containerView.frame.size.width - titleLabel.frame.size.width) * half
        titleLabel.frame.origin.y = (containerView.frame.size.height - titleLabel.frame.size.height) * half
        containerView.addSubview(titleLabel)
    }
    
    //Sets up the Login and Signup buttons
    func createButtons(containerView: UIView) {
        
        let margin: CGFloat = 15.0
        let middleSpacing: CGFloat = 7.5
        
        let signUp = UIButton()
        signUp.setTitle("Sign In", forState: .Normal)
        signUp.setTitleColor(UIColor.blackColor(), forState: .Normal)
        signUp.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 0.8)
        signUp.frame.size.width = (((containerView.frame.size.width - signUp.frame.size.width) - (margin * 2)) / 2 - middleSpacing)
        signUp.frame.size.height = 40.0
        signUp.frame.origin.x = margin
        signUp.frame.origin.y = ((containerView.frame.size.height - signUp.frame.size.height) - 25.0)
        signUp.addTarget(self, action: "signUpTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        containerView.addSubview(signUp)
        
        let register = UIButton()
        register.setTitle("Register", forState: .Normal)
        register.setTitleColor(UIColor.blackColor(), forState: .Normal)
        register.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 0.8)
        register.frame.size.width = (((containerView.frame.size.width - register.frame.size.width) - (margin * 2)) / 2 - middleSpacing)
        register.frame.size.height = 40.0
        register.frame.origin.x = ((containerView.frame.size.width - register.frame.size.width) - margin)
        register.frame.origin.y = ((containerView.frame.size.height - register.frame.size.height) - 25.0)
        register.addTarget(self, action: "registerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        containerView.addSubview(register)
    }
    
    //Action functions when Signup/Register is tapped
    func signUpTapped(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewControllerWithIdentifier("signup") as! SignUpViewController
        signupVC.buttonTitlePressed = sender.titleLabel?.text
        let navigationController = UINavigationController(rootViewController: signupVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func registerTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewControllerWithIdentifier("signup") as! SignUpViewController
        let navigationController = UINavigationController(rootViewController: signupVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
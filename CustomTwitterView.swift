//
//  CustomTwitterView.swift
//  pictune
//
//  Created by David Lilue on 11/3/16.
//  Copyright © 2016 Pictune. All rights reserved.
//

import Foundation

class CustomTwitterView: UIViewController, UITextViewDelegate
{
    var blur_effect : UIBlurEffect!
    var blur_effect_view : UIVisualEffectView!
    
    var bottom_label : UILabel!
    
    var body_frame : UIView!
    
    var horizontal_line_separator : UIView!
    var vertical_line_separator : UIView!
    
    var twitter_text : UITextView!
    
    var post_button : UIButton!
    var cancel_button : UIButton!
    
    var waiting : UIActivityIndicatorView!
    var waiting_background : UIView!
    var waiting_blur_view : UIVisualEffectView!
    
    var twitter_sent : UILabel!
    
    var twitter_function : ((String) -> ())!
    
    var body_width : CGFloat!
    var body_height : CGFloat!
    
    var position_x : CGFloat!
    var position_y : CGFloat!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let corner_radious : CGFloat = 20.0
        
        body_width = 258.0
        body_height = 200.0
        
        position_x = self.view.center.x - (body_width / 2.0)
        position_y = self.view.center.y - 237.0

        let button_width = (body_width / 2.0)
        let button_height =  (body_height * 0.2)
        
        let bottom_label_width = (body_width * 0.1)
        let bottom_label_height = (body_height * 0.125)
        
        let tweet_top_margin : CGFloat = 5.0
        let tweet_bottom_margin : CGFloat = 5.0
        let tweet_left_margin : CGFloat = 10.0
        let tweet_rigth_margin : CGFloat = 10.0
        
        let tweet_width = body_width - tweet_left_margin - tweet_rigth_margin
        let tweet_height = body_height - button_height - bottom_label_height - tweet_top_margin - tweet_bottom_margin
        
        // Transparent background. Related with UIModalPresentationStyle.OverCurrentContext
        self.view.backgroundColor = UIColor.clear
        
        // Blur background
        self.blur_effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        self.blur_effect_view = UIVisualEffectView(effect: blur_effect)
        self.blur_effect_view.frame = view.bounds
        self.blur_effect_view.backgroundColor = UIColor.black

        // Twitter post frame where the buttons and textview are.
        self.body_frame = UIView(
            frame : CGRect(
                x : position_x,
                y : position_y,
                width : body_width,
                height : body_height
            )
        )
        self.body_frame.backgroundColor = UIColor.white
        self.body_frame.layer.borderColor = UIColor.black.cgColor
        self.body_frame.layer.borderWidth = 0.1
        self.body_frame.layer.cornerRadius = corner_radious
        
        // Adding the blur and body to the current view
        self.view.addSubview(blur_effect_view)
        self.view.addSubview(body_frame)
        
        // Post button
        self.post_button = UIButton(
            frame : CGRect(
                x : button_width,
                y : 0,
                width : button_width,
                height : button_height
            )
        )
        self.post_button.setTitle("Post", for: UIControlState())
        self.post_button.setTitleColor(UIColor.blue, for: UIControlState())
        self.post_button.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        self.post_button.layer.cornerRadius = corner_radious
        self.post_button.addTarget(self,
                                   action : #selector(CustomTwitterView.post_clicked),
                                   for : UIControlEvents.touchUpInside)
        
        self.body_frame.addSubview(post_button)
        
        // Cancel button
        self.cancel_button = UIButton(
            frame : CGRect(
                x : 0,
                y : 0,
                width : button_width,
                height : button_height
            )
        )
        self.cancel_button.setTitle("Cancel", for: UIControlState())
        self.cancel_button.setTitleColor(UIColor.red, for: UIControlState())
        self.cancel_button.layer.cornerRadius = corner_radious
        self.cancel_button.addTarget(self,
                                     action : #selector(CustomTwitterView.cancel_clicked),
                                     for : UIControlEvents.touchUpInside)
        
        self.body_frame.addSubview(cancel_button)
        
        // Line separators. Between buttons and frame
        
        // Horizontal. Buttons/Frame
        self.horizontal_line_separator = UIView(
            frame : CGRect(
                x : 0,
                y : button_height,
                width: body_width,
                height: 1
            )
        )
        self.horizontal_line_separator.backgroundColor = UIColor.gray
        
        // Vertical. Button/Button
        self.vertical_line_separator = UIView(
            frame : CGRect(
                x : button_width,
                y : 0,
                width : 1,
                height : button_height
            )
        )
        self.vertical_line_separator.backgroundColor = UIColor.gray
        
        self.body_frame.addSubview(horizontal_line_separator)
        self.body_frame.addSubview(vertical_line_separator)
        
        // Tweet text
        self.twitter_text = UITextView(
            frame : CGRect(
                x : tweet_left_margin,
                y : button_height + tweet_top_margin,
                width : tweet_width,
                height : tweet_height
            )
        )
        self.twitter_text.backgroundColor = UIColor.clear
        self.twitter_text.font = UIFont(name: "Heiti SC", size: 14)
        
        self.body_frame.addSubview(twitter_text)

        // Bottom label. Characters counter
        self.bottom_label = UILabel(
            frame : CGRect(
                x : body_width - bottom_label_width - 10,
                y : button_height + tweet_top_margin + tweet_height + tweet_bottom_margin + 1,
                width : bottom_label_width,
                height : bottom_label_height
            )
        )
        self.bottom_label.font = UIFont(name: "Heiti SC", size: 11)
        
        self.body_frame.addSubview(bottom_label)
        
        // Waiting inidicator while sending tweet
        self.waiting = UIActivityIndicatorView()
        self.waiting.center.x = body_width / 2.0
        self.waiting.center.y = body_height / 2.0
        self.waiting.hidesWhenStopped = true
        self.waiting.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        // Dark background frame for the waitting indicator
        self.waiting_background = UIView(
            frame : CGRect(
                x : body_width / 2.0 - 50,
                y : body_height / 2.0 - 50,
                width : 100,
                height : 100
            )
        )
        self.waiting_background.backgroundColor = UIColor.black
        self.waiting_background.layer.cornerRadius = corner_radious
        
        self.body_frame.addSubview(waiting_background)
        self.body_frame.addSubview(waiting)
        
        // Setting alphas to hide UIViews
        self.blur_effect_view.alpha = 0
        self.body_frame.alpha = 0
        self.post_button.alpha = 0
        self.cancel_button.alpha = 0
        self.horizontal_line_separator.alpha = 0
        self.vertical_line_separator.alpha = 0
        self.twitter_text.alpha = 0
        self.bottom_label.alpha = 0
        // Waiting frame
        self.waiting.alpha = 0
        self.waiting_background.alpha = 0
        
        self.twitter_text.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UIView.animate(withDuration: 1, animations: {
            self.blur_effect_view.alpha = 0.6
            self.body_frame.alpha = 1
            self.post_button.alpha = 1
            self.cancel_button.alpha = 1
            self.horizontal_line_separator.alpha = 0.8
            self.vertical_line_separator.alpha = 0.8
            self.twitter_text.alpha = 1
            self.bottom_label.alpha = 1
        })
        
        self.bottom_label.text = "140"
        self.twitter_text.becomeFirstResponder()
    }
    
    
    func post_clicked()
    {
        self.post_button.alpha = 0.5
        self.waiting.startAnimating()
        self.twitter_text.resignFirstResponder()
        
        UIView.animate(withDuration: 1, animations: {
            self.blur_effect_view.alpha = 0
            self.body_frame.alpha = 0
            self.post_button.alpha = 0
            self.cancel_button.alpha = 0
            self.horizontal_line_separator.alpha = 0
            self.vertical_line_separator.alpha = 0
            self.twitter_text.alpha = 0
            self.bottom_label.alpha = 0
            //self.waiting.alpha = 1
            //self.waiting_background.alpha = 0.6
        }, completion: { (Bool) -> () in
            self.blur_effect_view.removeFromSuperview()
            self.body_frame.removeFromSuperview()
            self.post_button.removeFromSuperview()
            self.cancel_button.removeFromSuperview()
            self.horizontal_line_separator.removeFromSuperview()
            self.vertical_line_separator.removeFromSuperview()
            self.twitter_text.removeFromSuperview()
            self.bottom_label.removeFromSuperview()
            
            self.twitter_function(self.twitter_text.text!) //, completion_handler)
        }) 
        self.dismiss(animated: false, completion: nil)
    }
    
    func cancel_clicked()
    {
        self.cancel_button.alpha = 0.5
        self.twitter_text.resignFirstResponder()
        
        UIView.animate(withDuration: 1, animations: {
            self.blur_effect_view.alpha = 0
            self.body_frame.alpha = 0
            self.post_button.alpha = 0
            self.cancel_button.alpha = 0
            self.horizontal_line_separator.alpha = 0
            self.vertical_line_separator.alpha = 0
            self.twitter_text.alpha = 0
            self.bottom_label.alpha = 0
        }, completion: { (Bool) -> () in
            self.blur_effect_view.removeFromSuperview()
            self.body_frame.removeFromSuperview()
            self.post_button.removeFromSuperview()
            self.cancel_button.removeFromSuperview()
            self.horizontal_line_separator.removeFromSuperview()
            self.vertical_line_separator.removeFromSuperview()
            self.twitter_text.removeFromSuperview()
            self.bottom_label.removeFromSuperview()
            self.waiting_background.removeFromSuperview()
            self.waiting.removeFromSuperview()
            
            self.dismiss(animated: false, completion: nil)
        }) 
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range:NSRange, replacementText text:String ) -> Bool
    {
        let tweet_length = self.twitter_text.text!.utf16.count + text.utf16.count - range.length
        
        self.bottom_label.text = "\(140 - tweet_length)"
        
        if tweet_length <= 140 {
            self.bottom_label.textColor = UIColor.black
            self.post_button.isEnabled = true
        } else {
            self.bottom_label.textColor = UIColor.red
            self.post_button.isEnabled = false
        }
        
        return true
    }
    
    func keyboardWillShow(_ sender: Notification)
    {
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        //let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size

        if (offset.height + self.body_height + 15) >= self.view.bounds.maxY {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                //self.body_frame.center.x = self.view.center.x
                self.body_frame.center.y = self.body_height / 2.0 + 15
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                //self.body_frame.center.x = self.view.center.x
                self.body_frame.center.y = self.view.bounds.maxY - offset.height - self.body_height / 2.0 - 15
            })
        }
    }
    
    func keyboardWillHide(_ sender: Notification)
    {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.body_frame.center.y = self.view.center.y
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.blur_effect_view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.height, height: self.view.bounds.width)
            self.body_frame.center.x = self.view.center.y
            self.body_frame.center.y = self.view.center.x
        })
    }
}

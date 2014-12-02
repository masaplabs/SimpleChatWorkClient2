//
//  LoadingViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/26.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, LTMorphingLabelDelegate {
    
    // MARK: - Properties
    
    var loadingLabel = LTMorphingLabel(forAutoLayout: ())
    var loadingCount: Int = 0
    let textArray = ["Simple ChatWork", "now loading...", "One moment, please."]
    
    var textIndex = 1
    var loadingText:String {
        get {
            if textIndex >= countElements(textArray) {
                textIndex = 0
            }
            return textArray[textIndex++]
        }
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.whiteColor()
        
        self.renderView()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: Selector("changeLabel:"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Method
    
    // View を描画する
    private func renderView() -> Void {
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.morphingEffect = .Scale
        
        self.view.addSubview(loadingLabel)
        
        loadingLabel.autoCenterInSuperview()
        loadingLabel.autoSetDimension(ALDimension.Height, toSize: 50)
        loadingLabel.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 40.0)
        loadingLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 40.0)
        
        loadingLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        loadingLabel.text = textArray[0]
    }
    
    // MARK: - Event Method
    
    func changeLabel(timer: NSTimer) {
        loadingLabel.text = loadingText
        
        loadingCount++
        
        if (loadingCount >= 1) {
            timer.invalidate()
            
            var endTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: Selector("closeView"), userInfo: nil, repeats: false)
        }
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//
//  WebToJSController.swift
//  WebViewDemo
//
//  Created by baron on 16/9/7.
//  Copyright © 2016年 baron. All rights reserved.
//

import UIKit
import JavaScriptCore

class WebToJSController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var context: JSContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.context = JSContext()
        let url = NSBundle.mainBundle().URLForResource("testJS", withExtension: "js")
        let stringTest = try? String.init(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
        self.context?.evaluateScript(stringTest);
    }
    
    @IBAction func loadMethod(sender: AnyObject) {
        
        self.context?.evaluateScript("alertResponseOc()")
        
    }
    
    @IBAction func loadWithParameters(sender: UIButton) {
        
        sender.selected = !sender.selected
        let tmpInt = sender.selected ? 30 : 15
        let value = self.context?.objectForKeyedSubscript("showResult")
        let reult = value?.callWithArguments([tmpInt])
        
        titleLabel.text = "结果：\(reult?.toNumber().integerValue)"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

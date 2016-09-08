//
//  ViewController.swift
//  WebViewDemo
//
//  Created by baron on 16/9/7.
//  Copyright © 2016年 baron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toOCButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toOCButtonHandle(sender: AnyObject) {
        
        performSegueWithIdentifier("toOC", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toOC" {
            
            let  receive = segue.destinationViewController
            receive.title = "JS to OC"
        }
        
    }

   
    @IBAction func toJSButtonHandle(sender: AnyObject) {
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let receive = board.instantiateViewControllerWithIdentifier("toJS")
        receive.title = "OC to JS"
        navigationController?.pushViewController(receive, animated: true)
    }
    
}


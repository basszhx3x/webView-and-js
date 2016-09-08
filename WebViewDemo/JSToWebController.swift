

import UIKit
import JavaScriptCore

@objc protocol JSTestDelegate: JSExport {
    
    func pushController()    //测试模型js调用oc方法
    func calculateForJS()    //测试模型计算
}

@objc class JSObjcModel:NSObject,JSTestDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func pushController() {
        
        let array = JSContext.currentArguments()
        var index = 0
        var className:String?
        var title:String?
        for obj in array {
            
            switch index {
            case 0:
                className = obj.toString()
            default:
                title = obj.toString()
            }
            
            index += 1
        }
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let receive = board.instantiateViewControllerWithIdentifier(className!)
        receive.title = title
        controller!.navigationController?.pushViewController(receive, animated: true)
    
    }
    
    func calculateForJS() {
        
        let array = JSContext.currentArguments()
        let number = array[0].toNumber()
        
        let result = calculateFactorialOfNumber(number)
        let showResult = jsContext?.objectForKeyedSubscript("showResult")
        
        showResult?.callWithArguments([result])
    }
    
    func calculateFactorialOfNumber(number:NSNumber?) -> NSNumber {
    
        let i = number?.integerValue
        if i < 0 {
            return NSNumber(integer: 0)
        }
        if i==0 {
            return NSNumber(integer: 1)
        }
        
        let r = i! * (calculateFactorialOfNumber(NSNumber(integer: (i!-1))).integerValue)
        return NSNumber(integer: r)
    }
    
}

class JSToWebController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var context: JSContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        webView.backgroundColor = UIColor.clearColor()
        webView.delegate = self
        loadUrl()
        
        automaticallyAdjustsScrollViewInsets = false
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func loadUrl() {
    
        let filePath = NSBundle.mainBundle().pathForResource("JSCallOC", ofType: "html")
        webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: filePath!)))
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
        
        let model = JSObjcModel()
        model.controller = self
        self.context = context
        model.jsContext = self.context

        //设置模型 第一种调用方法
        self.context?.setObject(model, forKeyedSubscript: "app")
        let url = NSBundle.mainBundle().URLForResource("JSCallOC", withExtension: "html")
        self.context?.evaluateScript(try? String(contentsOfURL: url!, encoding: NSUTF8StringEncoding));

        self.context?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception)
        }
        
        
        
        //block 第二种方法
        let log: @convention(block) String -> Void = { value in
        
            print("js调用swift代码打印" + value)
        }
        self.context?.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "log")
        //绑定js中的log方法
        
        weak var weakSelf = self
        let alertHandle:@convention(block) String -> () = { value in
            
            let alertView = UIAlertController(title: "", message: "js 调用原生 ui", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (object) in
                
            }))
            weakSelf?.presentViewController(alertView, animated: true, completion: nil)
        }
        self.context?.setObject(unsafeBitCast(alertHandle, AnyObject.self), forKeyedSubscript: "alert")
        //绑定js中的alert方法
        
        print(self.context?.objectForKeyedSubscript("app"))
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

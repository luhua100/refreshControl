//
//  HZBottomRefreshControl.swift
//  GuangJiePlayer
//
//  Created by zyfMac on 2022/11/8.
//

import UIKit

let bottomConstuctFrameY : CGFloat = 60

let SCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.size.height


//MARK: - 默认状态 - 拉伸状态 - 刷新状态
enum bottomRefreshControlStatus : Int {
    case Normal ,Pulling , Refreshing
}

class HZBottomRefreshControl: UIView {
    
    var superScollView : UIScrollView?
    
    
    var currentStatus  : HeaderRefreshControlStatus = .Normal{
        didSet{
            
            if superScollView?.contentSize.height ?? 0 < SCREEN_HEIGHT - naviBarH {
                return
            }
            
            
            if currentStatus == .Normal {
                statusLabel.text = "上拉加载更多数据.."
            }else if currentStatus == .Pulling {
                statusLabel.text = "松手加载更多数据.."
            }else if currentStatus == .Refreshing {
                statusLabel.text = "正在加载更多数据.."
                //处理视图样式
                
                let top = (superScollView?.contentInset.top ?? 0)
                let left = (superScollView?.contentInset.left ?? 0)
                let bottom = (superScollView?.contentInset.bottom ?? 0)  + bottomConstuctFrameY
                let right = (superScollView?.contentInset.right ?? 0)
                
                UIView.animate(withDuration: 0.25) {
                    self.superScollView?.contentInset = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
                }
                
                if (self.bottomRefreshEvent != nil){
                    bottomRefreshEvent!()
                }
            }
        }
    }
    
    
    var statusH : CGFloat?{
        get{
            if #available(iOS 13.0, *) {
                return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height  ?? 0
            } else {
                return UIApplication.shared.statusBarFrame.size.height
            }
            
        }
    }
    
    var naviBarH : CGFloat{
        get{
            return statusH! + 44.0
        }
    }
    
    
    lazy var statusLabel: UILabel = { [weak self] in
        let  statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        statusLabel.text = "上拉加载更多数据.."
        return statusLabel
    }()
    
    
   public  var bottomRefreshEvent : (()->())?
   public func bottomEndRefresh() {
        if(currentStatus == .Refreshing){
            currentStatus = .Normal
        }
        
        UIView.animate(withDuration: 0.25) {
            let top = (self.superScollView?.contentInset.top ?? 0)
            let left = self.superScollView?.contentInset.left ?? 0
            let bottom = (self.superScollView?.contentInset.bottom ?? 0) - bottomConstuctFrameY
            let right = self.superScollView?.contentInset.right ?? 0
            self.superScollView?.contentInset = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
        }
        
        
    }
    
    override init(frame: CGRect) {
        let newFrame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: bottomConstuctFrameY)
        super.init(frame: newFrame)
        
        statusLabel.frame  = CGRect.init(x: 0, y: 0, width: 200, height: 22)
        statusLabel.center = self.center
        addSubview(statusLabel)
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //当视图加入到父控制器的时候会调用此方法
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if ((newSuperview?.isKind(of: UIScrollView.classForCoder())) != nil) {
            self.superScollView = newSuperview as? UIScrollView
            //KVO
            self.superScollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            self.superScollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
    }
    
    /*
     状态的改变
     拖动: normal -pulling,  pulling--normal
     松开:pulling - refreshing
     */
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            let contentSizeH : CGFloat = superScollView?.contentSize.height ?? 0
            if contentSizeH  >= SCREEN_HEIGHT - naviBarH {
                var frame = self.frame
                frame.origin.y = superScollView?.contentSize.height ?? 0
                self.frame = frame
            }else{
                currentStatus = .Normal
                statusLabel.text = ""
            }
        }else if keyPath == "contentOffset"{
            /*
             状态的改变
             拖动: normal -pulling,  pulling--normal
             松开:pulling - refreshing
             */
            let  totalH  : CGFloat = (superScollView?.contentOffset.y ?? 0) + (superScollView?.frame.size.height ?? 0)
            let  scrollH : CGFloat = (superScollView?.contentSize.height ?? 0) + bottomConstuctFrameY
            
            if superScollView?.isDragging == true{
                if currentStatus == .Pulling && totalH <  scrollH {
                    currentStatus = .Normal
                }else if currentStatus == .Normal  && totalH >=  scrollH {
                    currentStatus = .Pulling
                }
            }else {
                if currentStatus == .Pulling {
                    currentStatus = .Refreshing
                }
            }
            
        }
    }
    deinit {
        superScollView?.removeObserver(self, forKeyPath: "contentSize")
        superScollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}

public extension UIScrollView {
    
    struct RuntimeKeyBottom {
            
            static let kProgressHud = UnsafeRawPointer.init(bitPattern: "hz_bottom".hashValue)
            
        }
    
    
 public  var bottomRefreshControl : HZBottomRefreshControl? {
        set{
            
            objc_setAssociatedObject(self, UIScrollView.RuntimeKeyBottom.kProgressHud!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            var bottomRefreshControl = objc_getAssociatedObject(self, UIScrollView.RuntimeKeyBottom.kProgressHud!)  as? HZBottomRefreshControl
            if bottomRefreshControl == nil {
                bottomRefreshControl = HZBottomRefreshControl.init()
                self.addSubview(bottomRefreshControl!)
                //临时变量 需要重新保存一下  也就是调用setting
                self.bottomRefreshControl = bottomRefreshControl
            }
            return bottomRefreshControl
        }
    }
}

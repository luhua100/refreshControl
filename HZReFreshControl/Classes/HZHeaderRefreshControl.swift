//
//  HZHeaderRefreshControl.swift
//  GuangJiePlayer
//
//  Created by zyfMac on 2022/11/8.
//

import UIKit


let headerConstuctFrameY : CGFloat = 44

//MARK: - 默认状态 - 拉伸状态 - 刷新状态
enum HeaderRefreshControlStatus : Int {
   case Normal ,Pulling , Refreshing
}


class HZHeaderRefreshControl: UIView {
 
    //MARK: - 头部刷新的回调
   public var headerFreshControlEvent : (()->())?
    
    var currentStatus  : HeaderRefreshControlStatus = .Normal{
        didSet{
            if currentStatus == .Normal {
                statusLabel.text = "下拉刷新最新数据.."
            }else if currentStatus == .Pulling {
                statusLabel.text = "松开刷新最新数据.."
            }else if currentStatus == .Refreshing {
                statusLabel.text = "正在刷新最新数据.."
                
                //处理视图样式
                
                let top = (superScollView?.contentInset.top ?? 0) + headerConstuctFrameY
                let left = superScollView?.contentInset.left ?? 0
                let bottom = superScollView?.contentInset.bottom ?? 0
                let right = superScollView?.contentInset.right ?? 0
                
                UIView.animate(withDuration: 0.25) {
                    self.superScollView?.contentInset = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
                }
                
                if self.headerFreshControlEvent != nil {
                    headerFreshControlEvent!()
                }
                
            }
        }
    }
    
    var superScollView : UIScrollView?
    
    lazy var statusLabel: UILabel = { [weak self] in
        let  statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        statusLabel.text = "下拉刷新最新数据"
        return statusLabel
    }()
    override init(frame: CGRect) {
    
        let newFrame = CGRect.init(x: 0, y: -headerConstuctFrameY, width: UIScreen.main.bounds.size.width, height: headerConstuctFrameY)
        
        super.init(frame: newFrame)
        backgroundColor = .red
        statusLabel.frame = CGRect.init(x: 0, y: (self.frame.size.height / 2) - 11, width: self.frame.size.width, height: 22)
       // statusLabel.center = self.center
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
        }
    }
    
    /*
     状态的改变
     拖动: normal -pulling,  pulling--normal
     松开:pulling - refreshing
     */
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let maxOffset = -headerConstuctFrameY
            if superScollView?.isDragging == true { //拖动
                if superScollView?.contentOffset.y ?? 0 > maxOffset  && currentStatus == .Pulling {
                    currentStatus = .Normal
                }else if superScollView?.contentOffset.y ?? 0 <= maxOffset  && currentStatus == .Normal {
                    currentStatus = .Pulling
                }
            }else{ //松开
                if currentStatus == .Pulling {
                    currentStatus = .Refreshing
                }
            }
        }
    }
    
    
    //MARK: - 结束头部刷新的回调
   public func headerEndRefresh() {
        if currentStatus == .Refreshing {
            currentStatus = .Normal
            UIView.animate(withDuration: 0.25) {
                let top = (self.superScollView?.contentInset.top ?? 0) - headerConstuctFrameY
                let left = self.superScollView?.contentInset.left ?? 0
                let bottom = self.superScollView?.contentInset.bottom ?? 0
                let right = self.superScollView?.contentInset.right ?? 0
                self.superScollView?.contentInset = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
            }
        }
    }
    deinit {
        superScollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}

public extension UIScrollView {
    
    struct RuntimeKey {
            
            static let kProgressHud = UnsafeRawPointer.init(bitPattern: "hz_header".hashValue)
            
        }
    
    
  public  var headerRefreshControl : HZHeaderRefreshControl? {
        set{
            
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.kProgressHud!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            var headerControl = objc_getAssociatedObject(self, UIScrollView.RuntimeKey.kProgressHud!)  as? HZHeaderRefreshControl
            if headerControl == nil {
                headerControl = HZHeaderRefreshControl.init()
                self.addSubview(headerControl!)
                //临时变量 需要重新保存一下  也就是调用setting
                self.headerRefreshControl = headerControl
            }
            return headerControl
        }
    }
}

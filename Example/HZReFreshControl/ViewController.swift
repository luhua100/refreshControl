//
//  ViewController.swift
//  HZReFreshControl
//
//  Created by luhua100 on 11/08/2022.
//  Copyright (c) 2022 luhua100. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   let tableView = UITableView.init(frame: .zero, style: .plain)
//        tableView.headerRefreshControl?.headerFreshControlEvent = {
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//                self?.tableView.reloadData()
//                self?.tableView.headerRefreshControl?.headerEndRefresh()
//            }
//        }
//
//        tableView.bottomRefreshControl?.bottomRefreshEvent = {
//           // sleep(2)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//                self?.tableView.reloadData()
//                self?.tableView.bottomRefreshControl?.bottomEndRefresh()
//            }
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


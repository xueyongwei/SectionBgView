//
//  ViewController.swift
//  SectionBgView
//
//  Created by 薛永伟 on 2019/3/19.
//  Copyright © 2019年 薛永伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func onBtnClick(_ sender: UIButton) {
        
        let layout = YRbcsFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 15, bottom: 20, right: 15)
        layout.itemSize = CGSize.init(width: 200, height: 200)
        layout.fillModel = .fullSection
        layout.sectionCornerRadius = 5
        
        let vc = TestCollectionViewController.init(collectionViewLayout: layout)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


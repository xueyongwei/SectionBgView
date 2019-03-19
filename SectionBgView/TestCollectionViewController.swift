//
//  TestCollectionViewController.swift
//  SectionBgView
//
//  Created by 薛永伟 on 2019/3/19.
//  Copyright © 2019年 薛永伟. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.lightGray

        // Register cell classes
        self.collectionView!.register(ItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
    
        cell.titleLabel.text = "\(indexPath.section-indexPath.item)"
        return cell
    }


}

extension TestCollectionViewController:YRbcsDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, topOffSetAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, bottomOffSetAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
}

extension TestCollectionViewController {
    
    class ItemCell:UICollectionViewCell {
        
        lazy var titleLabel: UILabel = {
            
            let view = UILabel()
            view.textColor = UIColor.black
            view.textAlignment = .center
            view.font = UIFont.systemFont(ofSize: 14)
            return view
        }()
        
        lazy var spLine: UIView = {
            
            let view = UIView()
            view.backgroundColor = UIColor.lightGray
            return view
        }()
        
        override init(frame: CGRect) {
            
            super.init(frame: frame)
            customSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            
            fatalError("init(coder:) has not been implemented")
        }
        
        func customSubviews(){
            
            backgroundColor = UIColor.red
            
            contentView.addSubview(spLine)
            spLine.translatesAutoresizingMaskIntoConstraints = false
            spLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
            spLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
            spLine.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
            spLine.heightAnchor.constraint(equalToConstant: 0.5)
            
            contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        }
    }
}

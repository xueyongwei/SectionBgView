//
//  ACollectionViewFlowLayout.swift
//  collection
//
//  Created by 薛永伟 on 2018/10/24.
//  Copyright © 2018年 薛永伟. All rights reserved.
//

import UIKit

/** Yuri Background Color Section `s UICollectionViewFlowLayout
 高频次使用的，每个分组一个背景色，或者每个分组都有一个圆角容器包裹，使用此FlowLayout，实现相应定制代理即可。
 */


/// 装饰视图
class YRbcsDecorationView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        if let att = layoutAttributes as? YRbcsLayoutAttributes {
            self.backgroundColor =  att.bgColor
            self.layer.cornerRadius = att.cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        customSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        customSubviews()
    }
    
    func customSubviews(){
        
        self.backgroundColor =  .white
        self.layer.cornerRadius = 10
    }
}

/// LayoutAttributes
class YRbcsLayoutAttributes: UICollectionViewLayoutAttributes{
    
    var bgColor = UIColor.white
    var cornerRadius:CGFloat = 10
    
    /// 标识符
    static var decorationViewKind = "decorationViewKind"
    
}

/// 遵循这个协议，实现特殊定制
protocol YRbcsDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    
    /// 背景色
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
    
    /// 向上偏移量
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, topOffSetAt section: Int) -> CGFloat
    
    /// 向下偏移量
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, bottomOffSetAt section: Int) -> CGFloat
    
}

/// Yuri Background Color Section `s UICollectionViewFlowLayout
class YRbcsFlowLayout: UICollectionViewFlowLayout {
    
    enum FillModel {
        /// 紧凑(贴紧Cell)
        case compact
        /// 考虑sectionInset
        case sectionInset
        /// 整个section
        case fullSection
    }
    
    fileprivate var decorationAtts = [YRbcsLayoutAttributes]()
    
    /// 是否填充整个section
    var fillModel: FillModel = .compact
    /// 分组的圆角
    var sectionCornerRadius:CGFloat = 10
    
    override func prepare() {
        
        super.prepare()
        
        
        self.register(YRbcsDecorationView.self, forDecorationViewOfKind: YRbcsLayoutAttributes.decorationViewKind)
        
        guard let deleagte = self.collectionView?.delegate as? YRbcsDelegateFlowLayout,let numberOfSections = self.collectionView?.numberOfSections else { return  }
        
        decorationAtts.removeAll()
        for section in 0..<numberOfSections {
            
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),numberOfItems > 0 ,
            let firstItem = self.layoutAttributesForItem(at: IndexPath.init(item: 0, section: section)),
            let lastItem = self.layoutAttributesForItem(at: IndexPath.init(item: numberOfItems - 1, section: section))
            else {
                continue
            }
            
            // sectionInset
            var sectionInset = self.sectionInset
            if let inset = deleagte.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section){
                sectionInset = inset
            }
            // sectionFrame，紧缩包含所有的item
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            
            // 根据填充模式计算起始坐标
            switch fillModel {
            case .compact:
                break
            case .sectionInset:
                sectionFrame.origin.x = sectionInset.left
                sectionFrame.origin.y = sectionInset.top
                break
            case .fullSection:
                sectionFrame.origin.x = 0
                sectionFrame.origin.y = 0
                break
            }
            
           // 根据填充模式计算大小
            switch fillModel {
            case .compact:
                break
            case .sectionInset:
                let sectionWidth = (sectionInset.left + sectionInset.right)
                sectionFrame.size.width = collectionViewContentSize.width - sectionWidth
                let sectionHeight = (sectionInset.left + sectionInset.right)
                sectionFrame.size.height = collectionViewContentSize.height - sectionHeight
                break
            case .fullSection:
                sectionFrame.size.width = collectionViewContentSize.width
                sectionFrame.size.height = collectionViewContentSize.height
                break
            }
            
            // 是否有顶部的偏移量
            let headerOffset = deleagte.collectionView(self.collectionView!, layout: self, topOffSetAt: section)
            sectionFrame.origin.y -=  headerOffset
            sectionFrame.size.height += headerOffset
            
            // 是否有底部的偏移量
            let footerOffset = deleagte.collectionView(self.collectionView!, layout: self, bottomOffSetAt: section)
            sectionFrame.size.height += footerOffset
            
            /// 创建一个attribute
            let newAtt = YRbcsLayoutAttributes(forDecorationViewOfKind: YRbcsLayoutAttributes.decorationViewKind, with: IndexPath(item: 0, section: section))
            newAtt.frame = sectionFrame
            newAtt.zIndex = -1
            
            newAtt.bgColor = deleagte.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            newAtt.cornerRadius = sectionCornerRadius
            
            decorationAtts.append(newAtt)
        }
        
    }
    
    override func layoutAttributesForElements(in rect  : CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attrs = super.layoutAttributesForElements(in: rect)
        let bgAtts = self.decorationAtts.filter({ (att) -> Bool in
            return rect.intersects(att.frame)
        })
        attrs?.append(contentsOf: bgAtts)
        
        return attrs
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
}


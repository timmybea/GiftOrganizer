//
//  ScrollSettingsTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol ScrollingSettingsCellDelegate {
    func optionChanged(to option: String)
}

class ScrollSettingsTableViewCell: UITableViewCell {

    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.clear
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = true
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    let tapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var args: [String]? {
        didSet {
            self.use = CellUse(rawValue: (args?.first)!)
        }
    }
    
    private var use: CellUse? {
        didSet {
            setupCell()
        }
    }
    
    private var datasource: [String]? {
        didSet {
            setupContentView()
        }
    }
    
    private var input: [String]?
    
    var selectedOption: String! {
        didSet {
            print("SELECTED: \(selectedOption)")
            self.delegate?.optionChanged(to: selectedOption)
        }
    }
    
    var delegate: ScrollingSettingsCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    private func setupCell() {
        
        let cellFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
        
        scrollView.frame = CGRect(x: -((100 + pad) - cellFrame.width),
                                  y: 0,
                                  width: CGFloat(100 + pad),
                                  height: cellFrame.height)
        self.addSubview(scrollView)
        
        tapView.frame = cellFrame
        self.addSubview(tapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap(sender:)))
        tapView.addGestureRecognizer(tapGesture)
        
        self.textLabel?.text = use?.labelText
        self.textLabel?.textColor = Theme.colors.charcoal.color
        
        self.datasource = use?.scrollOptions
    }
    
    private func setupContentView() {
        
        guard var tempInput = datasource else { return }
        
        let firstLast = (tempInput.first, tempInput.last)
        tempInput.append(firstLast.0!)
        tempInput.insert(firstLast.1!, at: 0)
        self.input = tempInput
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(self.input!.count),
                                             height: scrollView.frame.size.height)
        
        for i in 0..<self.input!.count {
            var frame = CGRect()
            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = scrollView.frame.size
            
            let label = UILabel(frame: frame)
            label.textColor = Theme.colors.charcoal.color
            label.text = self.input![i]
            self.scrollView.addSubview(label)
        }
        let index = 0 //datasource?.index(of: "option two") ?? <<<LOAD IN EXISTING SETTING
        scrollView.contentOffset = CGPoint(x: (scrollView.frame.width * CGFloat(index + 1)), y: 0)
        self.selectedOption = datasource![index]
    }
    
    @objc
    func didReceiveTap(sender: UITapGestureRecognizer) {
        
        var index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        index = index < datasource!.count ? index : 0
        self.selectedOption = datasource![index]
        
        let x = scrollView.contentOffset.x
        let nextRect = CGRect(x: x + scrollView.frame.width,
                              y: 0,
                              width: scrollView.frame.width,
                              height: scrollView.frame.height)
        
        scrollView.scrollRectToVisible(nextRect, animated: true)
    }
    
    enum CellUse: String {
        case rounding
        
        var labelText: String {
            switch self {
            case .rounding:
                return "Round to nearest"
            }
        }
        
        var scrollOptions: [String] {
            switch self {
            case .rounding:
                return ["$0.01","$0.25", "$0.50", "$1.00"]
            }
        }
    }
}

extension ScrollSettingsTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.input != nil else { return }
        let x = scrollView.contentOffset.x
        if x >=  scrollView.frame.size.width * CGFloat(self.input!.count - 1) {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width , y: 0)
        } else if x < scrollView.frame.width {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(self.input!.count - 2), y: 0)
        }
    }
}

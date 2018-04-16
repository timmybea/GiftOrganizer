//
//  AddGiftView.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-19.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol AddGiftViewDelegate {
    func addGiftViewWasTouched()
    func needsToResize(to height: CGFloat)
}

class AddGiftView: UIView {
    
    static var headerHeight: CGFloat = 24.0
    
    private var gifts = [Gift]()
    
    private let touchView: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Gift"
        label.textColor = UIColor.white
        label.font = Theme.fonts.boldSubtitleText.font
        label.textAlignment = .left
        return label
    }()
    
    private let giftImage: UIImageView = {
        let image = UIImage(named: ImageNames.gift.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let underline: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.bounces = false
        tv.backgroundColor = UIColor.clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(AddGiftViewCell.self, forCellReuseIdentifier: "AddGiftViewCell")
        return tv
    }()
    
    private let bottomUnderline: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    }()
    
    private let costLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.white
        l.font = Theme.fonts.mediumText.font
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .right
        l.text = "Total: $20.00"
        return l
    }()
    
    
    var delegate: AddGiftViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews()
        
        touchView.addTarget(self, action: #selector(didTouchDownSelf), for: .touchDown)
        touchView.addTarget(self, action: #selector(didTouchUpSelf), for: .touchUpInside)
    }
    
    private func layoutViews() {
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])

        self.addSubview(underline)
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            underline.leftAnchor.constraint(equalTo: self.leftAnchor),
            underline.rightAnchor.constraint(equalTo: self.rightAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)
            ])

        self.addSubview(giftImage)
        NSLayoutConstraint.activate([
            giftImage.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            giftImage.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -pad),
            giftImage.heightAnchor.constraint(equalToConstant: 18),
            giftImage.widthAnchor.constraint(equalToConstant: 18),
            ])

        self.addSubview(touchView)
        bringSubview(toFront: touchView)
        NSLayoutConstraint.activate([
            touchView.leftAnchor.constraint(equalTo: self.leftAnchor),
            touchView.rightAnchor.constraint(equalTo: self.rightAnchor),
            touchView.topAnchor.constraint(equalTo: self.topAnchor),
            touchView.heightAnchor.constraint(equalToConstant: AddGiftView.headerHeight)
            ])

    }
    
    func getGifts() -> [Gift]? {
        return self.gifts.isEmpty ? nil : self.gifts
    }
    
    func setGifts(_ gifts: [Gift]) {
        self.gifts = gifts
        self.delegate?.needsToResize(to: calculateNewHeight())
        setupTableView()
    }
    
    func addGiftToList(_ gift: Gift) {
        
        if !gifts.contains(gift) {
            self.gifts.append(gift)
            self.delegate?.needsToResize(to: calculateNewHeight())
        }
    }
    
    private func calculateNewHeight() -> CGFloat {
        let footerHeight: CGFloat = gifts.count == 0 ? 0.0 : 30.0
        return type(of: self).headerHeight + 2 + (CGFloat(gifts.count) * AddGiftViewCell.cellHeight) + footerHeight
    }
    
    func setupTableView() {
        
        if gifts.count == 0 {
            tableView.removeFromSuperview()
            bottomUnderline.removeFromSuperview()
            costLabel.removeFromSuperview()
        }

        if gifts.count > 0 {
            
            if costLabel.superview == nil {
                addSubview(costLabel)
                NSLayoutConstraint.activate([
                    costLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                    costLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                    costLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                    ])
            }
            
            if bottomUnderline.superview == nil {
                addSubview(bottomUnderline)
                NSLayoutConstraint.activate([
                    bottomUnderline.bottomAnchor.constraint(equalTo: costLabel.topAnchor, constant: -4),
                    bottomUnderline.leftAnchor.constraint(equalTo: self.leftAnchor),
                    bottomUnderline.rightAnchor.constraint(equalTo: self.rightAnchor),
                    bottomUnderline.heightAnchor.constraint(equalToConstant: 2)
                    ])
            }
            
            if tableView.superview == nil {
                addSubview(tableView)
                NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: underline.bottomAnchor, constant: 2),
                    tableView.bottomAnchor.constraint(equalTo: bottomUnderline.topAnchor, constant: -2),
                    tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
                    ])
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            totalCostForLabel()
        }
    }
    
    private func totalCostForLabel() {
        var cost: Float = 0.0
        for g in gifts {
            cost += g.cost
        }
        let a = String(format: "%.2f", cost)
        costLabel.text = "Total cost: $\(a)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeEventIdFromAllGifts() {
        for gift in gifts {
            gift.eventId = nil
        }
    }
}

//MARK: touchView touched
extension AddGiftView {
    
    @objc
    func didTouchDownSelf() {

        self.giftImage.tintColor = Theme.colors.lightToneOne.color
        self.label.textColor = Theme.colors.lightToneOne.color
        self.underline.backgroundColor = Theme.colors.lightToneOne.color
    }
    
    @objc
    func didTouchUpSelf() {
        
        self.giftImage.tintColor = UIColor.white
        self.label.textColor = UIColor.white
        self.underline.backgroundColor = UIColor.white
        
        if self.delegate != nil {
            self.delegate?.addGiftViewWasTouched()
        }
    }
}

//MARK: AddGiftViewCellDelegate
extension AddGiftView : AddGiftViewCellDelegate {
    
    func remove(gift: Gift) {
        var row = 0
        for (i, g) in self.gifts.enumerated() {
            if g.id == gift.id {
                gift.eventId = nil
                gift.isCompleted = false
                row = i
                break
            }
        }
        self.gifts.remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        
        let fire = Date(timeInterval: 0.2, since: Date())
        let timer = Timer(fire: fire, interval: 0, repeats: false, block: { (timer) in
            self.delegate?.needsToResize(to: self.calculateNewHeight())
            timer.invalidate()
        })
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
}


extension AddGiftView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGiftViewCell") as! AddGiftViewCell
        let gift = gifts[indexPath.row]
        cell.setup(with: gift)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddGiftViewCell.cellHeight
    }
    
}

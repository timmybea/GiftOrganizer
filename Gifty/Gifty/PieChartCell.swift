//
//  PieChartCellTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-07.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import RKPieChart
import GiftyBridge

class PieChartCell: UITableViewCell {
    
    //MARK: properties
    private static var cellWidth: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - pad
    }
    
    private static var chartWidth: CGFloat {
            return  PieChartCell.cellWidth - (1 * pad) - (2 * chartPad)
    }
    
    private static let chartPad: CGFloat = 70
    
    static func heightForCell(for itemCount: Int) -> CGFloat {
        let tvHeight = tvCellHeight * CGFloat(itemCount)
        return PieChartCell.staticHeight + tvHeight
    }
    
    private static let staticHeight: CGFloat = pad + chartWidth + pad + 20 + smallPad + 2 + smallPad
    
    private static let tvCellHeight: CGFloat = 30

    var chartView: RKPieChartView?
    
    var tableDatasource: [ChartReportItem]?
    
    var totalSpent: Float = 0
    
    var totalGifts: Int = 0
    
    var isShowBudget = false
    
    private let colors = [UIColor.colorWithVals(r: 206, g: 78, b: 120),
                          UIColor.colorWithVals(r: 252, g: 158, b: 163),
                          UIColor.colorWithVals(r: 139, g: 24, b: 91),
                          UIColor.colorWithVals(r: 244, g: 197, b: 188),
                          UIColor.colorWithVals(r: 106, g: 28, b: 74),
                          UIColor.colorWithVals(r: 227, g: 105, b: 125),
                          UIColor.colorWithVals(r: 94, g: 5, b: 70),
                          UIColor.colorWithVals(r: 188, g: 70, b: 113),
                          UIColor.colorWithVals(r: 252, g: 180, b: 177)]
    
    //MARK: UI elements
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.clear
        tv.separatorColor = UIColor.clear
        tv.bounces = false
        tv.isScrollEnabled = true
        tv.allowsSelection = false
        tv.register(ChartReportCell.self, forCellReuseIdentifier: "ChartReportCell")
        return tv
    }()
    
    let summaryLabel: UILabel = {
        let label =  UILabel.createMediumLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.colors.charcoal.color
        return label
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = Theme.colors.lightToneOne.color
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataForChart(pieData: [PieData]?, budget: Bool) {
        
        if self.chartView != nil {
            self.chartView?.removeFromSuperview()
        }
        totalSpent = 0
        totalGifts = 0
        isShowBudget = budget
        
        var chartItems = [RKPieChartItem]()
        var reportItems = [ChartReportItem]()
        
        if pieData != nil {
            for (index, datum) in pieData!.enumerated() {
            let color = colors[index % colors.count]
                let ratio: uint = pieData!.count > 1 ? uint(datum.amtSpent * 100) : 999
                let chartItem = RKPieChartItem(ratio: ratio, color: color, title: datum.group)
                chartItems.append(chartItem)
                
                let reportItem = ChartReportItem(color: color, group: datum.group, numberGifts: datum.numberOfGifts, totalSpent: datum.amtSpent)
                reportItems.append(reportItem)
                
                totalSpent += datum.amtSpent
                totalGifts += datum.numberOfGifts
            }
        }

        self.chartView = RKPieChartView(items: chartItems)
        self.tableDatasource = reportItems
        configureChartView()
    }
    
    private func configureChartView() {
        guard let chartView = self.chartView else { return }
        chartView.backgroundColor = .clear
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = PieChartCell.chartWidth / 2
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = true //explains the sections
        chartView.isAnimationActivated = true
        
        layoutChart()
    }
    
    @objc
    func layoutChart() {
        
        self.summaryLabel.removeFromSuperview()
        self.divider.removeFromSuperview()
        self.tableView.removeFromSuperview()
        
        guard let chartView = self.chartView else { return }
        
        self.addSubview(chartView)
        chartView.heightAnchor.constraint(equalToConstant: PieChartCell.chartWidth).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: PieChartCell.chartWidth).isActive = true
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: pad).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -pad).isActive = true
        
        let action = isShowBudget ? "budgetted" : "spent"
        let prep = isShowBudget ? "for" : "on"
        let gift = totalGifts == 1 ? "gift" : "gifts"
        summaryLabel.text = "You have \(action) $\(String(format: "%.0f", totalSpent)) \(prep) \(totalGifts) \(gift)."

        self.addSubview(summaryLabel)
        summaryLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        summaryLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        summaryLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: pad).isActive = true
        
        self.addSubview(divider)
        divider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        divider.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: smallPad).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true

        tableView.frame = CGRect(x: 0,
                                 y: PieChartCell.staticHeight,
                                 width: UIScreen.main.bounds.width - pad - pad,
                                 height: PieChartCell.tvCellHeight * CGFloat(tableDatasource!.count))
        self.addSubview(tableView)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension PieChartCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDatasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartReportCell") as? ChartReportCell
        cell?.configureWith(chartReportItem: (tableDatasource?[indexPath.row])!)
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PieChartCell.tvCellHeight
    }
}

struct ChartReportItem {
    var color: UIColor
    var group: String
    var numberGifts: Int
    var totalSpent: Float
}

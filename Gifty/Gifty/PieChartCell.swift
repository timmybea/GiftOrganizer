//
//  PieChartCellTableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-07.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import RKPieChart

class PieChartCell: UITableViewCell {
    
    private var chartWidth: CGFloat {
            return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - (2 * pad) - (2 * chartPad)
    }
    
    private let chartPad: CGFloat = 70
    
    var chartView: RKPieChartView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let colors = [Theme.colors.buttonPurple.color,
                          Theme.colors.lightToneTwo.color,
                          Theme.colors.lightToneOne.color]
    
    func setDataForChart(pieData: [PieData]) {
        
        if self.chartView != nil {
            self.chartView?.removeFromSuperview()
        }
        
        var items = [RKPieChartItem]()
        for (index, datum) in pieData.enumerated() {
            
            let item = RKPieChartItem(ratio: uint(datum.amtSpent), color: colors[index % colors.count], title: datum.group)
            items.append(item)
        }
        self.chartView = RKPieChartView(items: items)
        configureChartView()
    }
    
    private func configureChartView() {
        guard let chartView = self.chartView else { return }
        chartView.backgroundColor = .clear
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = chartWidth / 2
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = true //explains the sections
        chartView.isAnimationActivated = true
        
        layoutChart()
    }
    
    private func layoutChart() {
        guard let chartView = self.chartView else { return }
        chartView.frame = CGRect(x: chartPad, y: pad, width: chartWidth, height: chartWidth)
        self.addSubview(chartView)
    }
}

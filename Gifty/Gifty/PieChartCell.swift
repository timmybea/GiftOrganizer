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
    
    private var cellWidth: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - pad
    }
    
    private var chartWidth: CGFloat {
            return  cellWidth - (1 * pad) - (2 * chartPad)
    }
    
    private let chartPad: CGFloat = 70
    
    var chartView: RKPieChartView?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.green
        tv.bounces = false
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
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
    
    @objc
    func layoutChart() {
        
        guard let chartView = self.chartView else { return }
        
        self.addSubview(chartView)
        chartView.heightAnchor.constraint(equalToConstant: chartWidth).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: chartWidth).isActive = true
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: pad).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -pad).isActive = true
        
        self.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: pad).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

extension PieChartCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

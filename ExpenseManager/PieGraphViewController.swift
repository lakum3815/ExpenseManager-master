//
//  SecondGraphsViewController.swift
//  
//
//  Created by Rishabh Thakkar on 1/4/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import Charts

class PieGraphViewController: UIViewController {
	//Setup storyboard connections and class variables
	@IBOutlet weak var pieChart: PieChartView!
	var expensesByCategory = [String: Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		updatePieGraph()
		print("piegraph Appear")
	}
	func updatePieGraph() {
		//Access keys of the dictionary, which are the expense categories
		let keys = Array(expensesByCategory.keys)
		//create array of PieChartDataEntries
		var entries = [PieChartDataEntry]()
		
		//loop through each category, create data entry and added to list of data entries
		for i in 0..<expensesByCategory.count {
			if(expensesByCategory[keys[i]]! > 0) {
				let dataEntry1 = PieChartDataEntry(value: expensesByCategory[keys[i]]!, label: keys[i])
				entries.append(dataEntry1) // here we add it to the data set
			}
		}
		
		// PieChartDataSet created from entries
		let set = PieChartDataSet( values: entries.reversed(), label: "Expenses")
		var colors: [UIColor] = []
		
		//set random colors for the pie chart sections
		for _ in 0..<keys.count {
			let red = Double(arc4random_uniform(256))
			let green = Double(arc4random_uniform(256))
			let blue = Double(arc4random_uniform(256))
			let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
			colors.append(color)
		}
		//Set the data and other descriptors for the PieChartView
		set.colors = colors
		let data = PieChartData(dataSet: set)
		pieChart.data = data
		pieChart.data?.setValueFormatter(YAxisValueFormatter())
		pieChart.chartDescription?.text = "Expenses by type"
		pieChart.noDataText = "No data available"
		pieChart.holeRadiusPercent = 0.2
		pieChart.transparentCircleColor = UIColor.clear
	}
}

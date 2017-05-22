//
//  Date.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//
import UIKit

extension Date {

	func yearsFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: NSCalendar.Options()).year!
	}
	func monthsFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: NSCalendar.Options()).month!
	}
	func weeksFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: NSCalendar.Options()).weekOfYear!
	}
	func daysFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: NSCalendar.Options()).day!
	}
	func hoursFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: NSCalendar.Options()).hour!
	}
	func minutesFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: NSCalendar.Options()).minute!
	}
	func secondsFrom(_ date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: NSCalendar.Options()).second!
	}
	var relativeTime: String {
		let now = Date()
		if now.yearsFrom(self) > 0 {
			return now.yearsFrom(self).description + " year" + { return now.yearsFrom(self) > 1 ? "s" : "" }() + " ago"
		}
		if now.monthsFrom(self) > 0 {
			return now.monthsFrom(self).description + " month" + { return now.monthsFrom(self) > 1 ? "s" : "" }() + " ago"
		}
		if now.weeksFrom(self) > 0 {
			return now.weeksFrom(self).description + " week" + { return now.weeksFrom(self) > 1 ? "s" : "" }() + " ago"
		}
		if now.daysFrom(self) > 0 {
			if now.daysFrom(self) == 1 { return "Yesterday" }
			return now.daysFrom(self).description + " days ago"
		}
		if now.hoursFrom(self) > 0 {
			return "\(now.hoursFrom(self)) hour" + { return now.hoursFrom(self) > 1 ? "s" : "" }() + " ago"
		}
		if now.minutesFrom(self) > 0 {
			return "\(now.minutesFrom(self)) minute" + { return now.minutesFrom(self) > 1 ? "s" : "" }() + " ago"
		}
		if now.secondsFrom(self) > 0 {
			if now.secondsFrom(self) < 15 { return "Just now" }
			return "\(now.secondsFrom(self)) second" + { return now.secondsFrom(self) > 1 ? "s" : "" }() + " ago"
		}
		return ""
	}
}

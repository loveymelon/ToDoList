//
//  CalendarViewController.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/16.
//

//Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value 오류 발생함 -> 해결방안 : 해당 클래스의 인스턴스를 만들고 present시 calendarView가 제대로 작동을 안할 수 있어서
// loginViewController에서 완벽하게 이 클래스 인스턴스가 생성후 접근 가능하도록 수정함
// 기존 코드는 그냥 label이 눌리면 바로 해당 클래스로 넘어오도록 설계했음

// dismiss해서 값을 HomewViewController의 calendarLabel의 값을 변경할때 표시하는 시점이 달라지므로 viewWillAppear로 선언
// 하지만 HomeViewController에서 label을 눌렀을때 sheet형식으로 present되므로 viewWillAppear을 쓸 수 없으므로 프로토콜 패턴을 써야된다.
protocol CalendarSelectionDelegate: AnyObject {
    func didSelectDate(_ dateComponents: DateComponents?)
}

import UIKit

class CalendarViewController: UIViewController, HandleDayDelegate {
    
    @IBOutlet weak var calendarView: UICalendarView!
    
    var homeViewController = HomeViewController()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    
    let calendar = Calendar.current
    let currentDate = Date()
    var previousSelectedDateComponents: DateComponents?
    
    weak var delegate: CalendarSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarSetting()
    }
    
    func calendarSetting() {
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
 
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        calendarView.setVisibleDateComponents(DateComponents(calendar: gregorianCalendar, year: currentDate.year, month: currentDate.month, day: currentDate.day), animated: true)
        
        setCalendarDate()
        self.homeViewController.dayDelegate = self
        calendarView.selectionBehavior = dateSelection
        
        if let previousDate = self.previousSelectedDateComponents {
            calendarView.visibleDateComponents = previousDate
        }
    }
    
    func setCalendarDate() {
        if let pastDate = calendar.date(byAdding: .year, value: -10, to: currentDate) {
            
            let fromDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: pastDate))!
            let toDate = calendar.date(byAdding: .year, value: 20, to: pastDate)!
            
            let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
            calendarView.availableDateRange = calendarViewDateRange
        }
    }
    
    func selectedDay(dates: [Int]) {
        //calendarView.visibleDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: dates[0], month: dates[1], day: dates[2])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        if calendarView.availableDateRange.contains((dateComponents?.date!)!) {
//            UserDefaults.standard.set(dateComponents, forKey: "selectedDate")
            delegate?.didSelectDate(dateComponents)
            selection.setSelected(selection.selectedDate, animated: false)
//            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "오류", message: "선택할 수 없는 날짜입니다. 유효한 범위는 현재 날짜로부터 10년 내에서 선택해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) {_ in
                
                self.delegate?.didSelectDate(self.calendarView.availableDateRange.closest(to: (dateComponents?.date)!, calendar: self.calendar))
            }
        }
    }
}

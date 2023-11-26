//
//  SuccessViewController.swift
//  ToDoList
//
//  Created by 김진수 on 2023/08/13.
//

import UIKit

//protocol LogoutDelegate{
//    func didLogoutSuccess()
//}
protocol HandleDayDelegate: AnyObject{
    func selectedDay(dates: [Int])
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calenderLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var weekendCollectionView: UICollectionView!
    @IBOutlet weak var todoTableView: UITableView!
    
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var weekDateArray: [String] = []
    var weekDayArray: [WeekDay] = []
    var selectedArray: [Bool] = Array(repeating: false, count: 7)
    var datesArray: [Int] = Array(repeating: 0, count: 3)
    var selectedDateComponents: DateComponents?
    
    weak var dayDelegate: HandleDayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiSetting()
    }
    
    func uiSetting() {
        labelAddGesture()
        setImageView()
        collectionViewSetting()
        tableViewSetting()
        setCalendarDate()
        
    }
    
    func labelAddGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedCalendarLabel))
        calenderLabel.isUserInteractionEnabled = true
        calenderLabel.addGestureRecognizer(gesture)
    }
    
    func setImageView() {
        iconImageView.image = UIImage(named: "iconImage")
    }
    
    func setCalendarDate() {
        dateFormatter.dateFormat = "dd"
        
        /*let currentStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfMonth], from: date))!*/
        let currentStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        let currentEndDate = calendar.date(byAdding: .day, value: 6, to: currentStartDate)!
        
        
        var currentWeekDate = currentStartDate
        
        while currentWeekDate <= currentEndDate {
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentWeekDate) {
                let day = calendar.component(.weekday, from: nextDate)
                currentWeekDate = nextDate
                weekDateArray.append(dateFormatter.string(from: currentWeekDate))
                weekDayArray.append(WeekDay(rawValue: day)!)
            } else {
                break
            }
        }
        
        if let index = weekDayArray.firstIndex(of:WeekDay(rawValue: calendar.component(.weekday, from: date))!) {
            selectedArray[index] = true
        }
        
        calenderLabel.text = date.toString()
        datesArray.replaceSubrange(0..<datesArray.count, with: [date.year, date.month, date.day])
        
    }
    
    func collectionViewSetting() {
        let layout = UICollectionViewFlowLayout()
        let collectionNibFile = UINib(nibName: "WeekendCollectionViewCell", bundle: nil) // collectionNib 파일

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        weekendCollectionView.dataSource = self
        weekendCollectionView.delegate = self
        
        weekendCollectionView.register(collectionNibFile, forCellWithReuseIdentifier: "WeekendCollectionCell")
        weekendCollectionView.collectionViewLayout = layout
    }
    
    func tableViewSetting() {
        let tableNibFile = UINib(nibName: "TodoTableViewCell", bundle: nil) // tableNib 파일
        
        todoTableView.register(tableNibFile, forCellReuseIdentifier: "TodoTableViewCell")
        todoTableView.rowHeight = 60
        
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
    }
    
    @objc func tappedCalendarLabel() {
        
        if let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController {
            calendarVC.delegate = self
            if let sheet = calendarVC.sheetPresentationController {
                sheet.detents = [.medium()]
                
    //            sheet.largestUndimmedDetentIdentifier = .medium
            }
            if self.selectedDateComponents != nil {
                calendarVC.previousSelectedDateComponents = self.selectedDateComponents
            }
            self.present(calendarVC, animated: true)
        }
        
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekendCollectionCell", for: indexPath) as? WeekendCollectionViewCell else { return UICollectionViewCell() }
        
        cell.dateLabel.text = weekDateArray[indexPath.item]
        cell.weekDayLabel.text = "\(weekDayArray[indexPath.item])"
        
        dateFormatter.dateFormat = "dd"
        
        // 이걸로 바꾸면 cell이 바뀔때마다 오늘 날짜도 상태가 true로 바뀌어서 selectedArray의 값에 true가 두 개가 된다.
//        if cell.dateLabel.text == dateFormatter.string(from: date) {
//            selectedArray[indexPath.item] = true
//        }
        
        cell.update(status: selectedArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width / 7, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if self.selectedArray[indexPath.item] == true {
            return false
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedArray.indices.forEach{ index in
            self.selectedArray[index] = false
        } // forEach는 배열의 내부 요소를 변경할 수 없다. 클러저 내부에서 값을 변경하여도 클러저 내부에만 영향이 미치기 때문이다. indices키워드는 배열의 각 인덱스에 직접 접근하는 키워드이다.
        self.selectedArray[indexPath.item] = true
        let cell = collectionView.cellForItem(at: indexPath) as! WeekendCollectionViewCell
        //year, month, day를 프로토콜 매개변수로 넣은 뒤 처리는 calendarViewController가 하도록 선언
        let day = weekDateArray[indexPath.item].compactMap{ Int(String($0)) }
        
        collectionView.reloadData()
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        
        cell.todoTableCellSetting()
        
        return cell
    }
    
}

extension HomeViewController: CalendarSelectionDelegate {
    func didSelectDate(_ dateComponents: DateComponents?) {
        self.selectedDateComponents = dateComponents
        
        if let year = dateComponents?.year, let month = dateComponents?.month, let day = dateComponents?.day {
            let dateArray = [year, month, day]
            self.datesArray.replaceSubrange(0..<datesArray.count, with: dateArray)
            calenderLabel.text = "\(dateArray[0])년 \(dateArray[1])월"
            let selectedDate = calendar.date(from: DateComponents(year: year, month: month, day: day))
            
            if let bindingDate = selectedDate {
                let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: bindingDate))!
                //.yearForWeekOfYear는 해당 주가 속한 연도, .weekOfYear는 해당 연도에 몇 번째 주에 속하는지
                // dateComponents로 선택된 날짜가 속한 주와 연도를 나타내는 DateComponents객체 생성
                let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
                var weekDate = weekStartDate
                
                dateFormatter.dateFormat = "dd"
                weekDateArray.removeAll()
                weekDayArray.removeAll()
                
                while weekDate <= weekEndDate {
                    
                    if let nextDate = calendar.date(byAdding: .day, value: 1, to: weekDate) {
                        let weekDay = calendar.component(.weekday, from: nextDate)
                        weekDate = nextDate
                        weekDateArray.append(dateFormatter.string(from: weekDate))
                        weekDayArray.append(WeekDay(rawValue: weekDay)!)
                    } else {
                        break
                    }
                }
                self.selectedArray.indices.forEach { index in
                    self.selectedArray[index] = false
                }
                
                if let index = weekDayArray.firstIndex(of:WeekDay(rawValue: calendar.component(.weekday, from: (dateComponents?.date)!))!) {
                    selectedArray[index] = true
                }
                self.weekendCollectionView.reloadData()
            }
            
        } else {
            print("empty Date")
        }
    }
}


import UIKit

open class MTPickerView: UIView {
  
  public typealias BtnAction = () -> Void
  public typealias SingleDoneAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
  public typealias MultipleDoneAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
  public typealias DateDoneAction = (_ selectedDate: Date) -> Void
  
  public typealias MultipleAssociatedDataType = [[[String: [String]?]]]
  fileprivate var pickerView: PickerView!
  fileprivate let pickerViewHeight:CGFloat = 260.0
  
  fileprivate let screenWidth = UIScreen.main.bounds.size.width
  fileprivate let screenHeight = UIScreen.main.bounds.size.height
  fileprivate var hideFrame: CGRect {
    return CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: pickerViewHeight)
  }
  fileprivate var showFrame: CGRect {
    return CGRect(x: 0.0, y: screenHeight - pickerViewHeight, width: screenWidth, height: pickerViewHeight)
  }
  
  
  convenience init(frame: CGRect, toolBarTitle: String, singleColData: [String], defaultSelectedIndex: Int?, doneAction: SingleDoneAction?) {
    
    self.init(frame: frame)
    
    pickerView = PickerView.singleColPicker(toolBarTitle, singleColData: singleColData, defaultIndex: defaultSelectedIndex, cancelAction: {[unowned self] in
      self.hidePicker()
      }, doneAction: {[unowned self] (selectedIndex, selectedValue) in
        doneAction?(selectedIndex, selectedValue)
        self.hidePicker()
    })
    pickerView.frame = hideFrame
    addSubview(pickerView)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
    addGestureRecognizer(tap)
  }
  
  convenience init(frame: CGRect, toolBarTitle: String, multipleColsData: [[String]], defaultSelectedIndexs: [Int]?, doneAction: MultipleDoneAction?) {
    
    self.init(frame: frame)
    
    pickerView = PickerView.multipleCosPicker(toolBarTitle, multipleColsData: multipleColsData, defaultSelectedIndexs: defaultSelectedIndexs, cancelAction: {[unowned self] in
      self.hidePicker()
      }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
        doneAction?(selectedIndexs, selectedValues)
        self.hidePicker()
    })
    pickerView.frame = hideFrame
    addSubview(pickerView)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
    addGestureRecognizer(tap)
  }
  
  convenience init(frame: CGRect, toolBarTitle: String, multipleAssociatedColsData: MultipleAssociatedDataType, defaultSelectedValues: [String]?, doneAction: MultipleDoneAction?) {
    self.init(frame: frame)
    pickerView = PickerView.multipleAssociatedCosPicker(toolBarTitle, multipleAssociatedColsData: multipleAssociatedColsData, defaultSelectedValues: defaultSelectedValues, cancelAction: {[unowned self] in
      self.hidePicker()
      }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
        doneAction?(selectedIndexs, selectedValues)
        self.hidePicker()
    })
    
    pickerView.frame = hideFrame
    addSubview(pickerView)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
    addGestureRecognizer(tap)
  }
  
  convenience init(frame: CGRect, toolBarTitle: String, datePickerSetting: DatePickerSetting, doneAction: DateDoneAction?) {
    self.init(frame: frame)
    pickerView = PickerView.datePicker(toolBarTitle, datePickerSetting: datePickerSetting, cancelAction:  {[unowned self] in
      self.hidePicker()
      }, doneAction: {[unowned self] (selectedDate) in
        doneAction?(selectedDate)
        self.hidePicker()
    })
    
    pickerView.frame = hideFrame
    addSubview(pickerView)
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
    addGestureRecognizer(tap)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addOrentationObserver()
  }
  
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK:- selector
extension MTPickerView {
  
  fileprivate func addOrentationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.statusBarOrientationChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
  }
  
  func statusBarOrientationChange() {
    removeFromSuperview()
  }
  
  func tapAction(_ tap: UITapGestureRecognizer) {
    let location = tap.location(in: self)
    if location.y <= screenHeight - pickerViewHeight {
      self.hidePicker()
    }
  }
}

extension MTPickerView {
  
  fileprivate func showPicker() {
    let window = UIApplication.shared.keyWindow
    guard let currentWindow = window else { return }
    currentWindow.addSubview(self)
    
    UIView.animate(withDuration: 0.25, animations: {[unowned self] in
      self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
      self.pickerView.frame = self.showFrame
      }, completion: nil)
  }
  
  func hidePicker() {
    UIView.animate(withDuration: 0.25, animations: { [unowned self] in
      self.backgroundColor = UIColor.clear
      self.pickerView.frame = self.hideFrame
      
      }, completion: {[unowned self] (_) in
        self.removeFromSuperview()
    })
  }
}

extension MTPickerView {
  
  public class func showSingleColPicker(_ toolBarTitle: String, data: [String], defaultSelectedIndex: Int?,  doneAction: SingleDoneAction?) {
    let window = UIApplication.shared.keyWindow
    guard let currentWindow = window else { return }
    
    let testView = MTPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, singleColData: data,defaultSelectedIndex: defaultSelectedIndex ,doneAction: doneAction)
    
    testView.showPicker()
  }
  
  public class func showMultipleColsPicker(_ toolBarTitle: String, data: [[String]], defaultSelectedIndexs: [Int]?,doneAction: MultipleDoneAction?) {
    let window = UIApplication.shared.keyWindow
    guard let currentWindow = window else { return }
    
    let testView = MTPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, multipleColsData: data, defaultSelectedIndexs: defaultSelectedIndexs, doneAction: doneAction)
    
    testView.showPicker()
  }
  
  public class func showMultipleAssociatedColsPicker(_ toolBarTitle: String, data: MultipleAssociatedDataType, defaultSelectedValues: [String]?, doneAction: MultipleDoneAction?) {
    let window = UIApplication.shared.keyWindow
    guard let currentWindow = window else { return }
    
    let testView = MTPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, multipleAssociatedColsData: data, defaultSelectedValues: defaultSelectedValues, doneAction: doneAction)
    
    testView.showPicker()
  }
  
  
  public class func showDatePicker(_ toolBarTitle: String, datePickerSetting: DatePickerSetting = DatePickerSetting(), doneAction: DateDoneAction?) {
    
    let window = UIApplication.shared.keyWindow
    guard let currentWindow = window else { return }
    
    let testView = MTPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, datePickerSetting: datePickerSetting, doneAction: doneAction)
    
    testView.showPicker()
  }
}



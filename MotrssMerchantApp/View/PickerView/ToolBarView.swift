
import UIKit

open class ToolBarView: UIView {
  
  typealias CustomClosures = (_ titleLabel: UILabel, _ cancleBtn: UIButton, _ doneBtn: UIButton) -> Void
  public typealias BtnAction = () -> Void
  
  open var title = "" {
    didSet {
      titleLabel.text = title
    }
  }
  
  open var doneAction: BtnAction?
  open var cancelAction: BtnAction?
  fileprivate lazy var contentView: UIView = {
    let content = UIView()
    content.backgroundColor = UIColor.white
    return content
  }()
  
  fileprivate lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.textAlignment = .center
    label.font =  UIFont(name: MTConstant.fontMavenProMedium, size: 16.0)
    return label
  }()
  
  fileprivate lazy var cancleBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("Cancel", for: UIControlState())
    btn.setTitleColor(UIColor.black, for: UIControlState())
    btn.titleLabel!.font =  UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)
    btn.titleLabel!.textColor = UIColor.appThemeColor
    btn.setTitleColor(UIColor.appThemeColor, for: .normal)
    return btn
  }()
  
  fileprivate lazy var doneBtn: UIButton = {
    let donebtn = UIButton()
    donebtn.setTitle("Done", for: UIControlState())
    donebtn.setTitleColor(UIColor.black, for: UIControlState())
    donebtn.titleLabel!.font =  UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)
    donebtn.setTitleColor(UIColor.appThemeColor, for: .normal)
    return donebtn
  }()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func commonInit() {
    backgroundColor = UIColor.lightText
    addSubview(contentView)
    contentView.addSubview(cancleBtn)
    contentView.addSubview(doneBtn)
    contentView.addSubview(titleLabel)
    
    doneBtn.addTarget(self, action: #selector(self.doneBtnOnClick(_:)), for: .touchUpInside)
    cancleBtn.addTarget(self, action: #selector(self.cancelBtnOnClick(_:)), for: .touchUpInside)
  }
  
  func doneBtnOnClick(_ sender: UIButton) {
    doneAction?()
  }
  func cancelBtnOnClick(_ sender: UIButton) {
    cancelAction?()
    
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    let margin = 15.0
    let contentHeight = Double(bounds.size.height) - 2.0
    contentView.frame = CGRect(x: 0.0, y: 1.0, width: Double(bounds.size.width), height: contentHeight)
    let btnWidth = contentHeight
    
    cancleBtn.frame = CGRect(x: margin, y: 0.0, width: btnWidth+10, height: btnWidth)
    doneBtn.frame = CGRect(x: Double(bounds.size.width) - btnWidth - margin, y: 0.0, width: btnWidth+10, height: btnWidth)
    let titleX = Double(cancleBtn.frame.maxX) + margin
    let titleW = Double(bounds.size.width) - titleX - btnWidth - margin
    
    //cancleBtn.backgroundColor = UIColor.green
    //doneBtn.backgroundColor = UIColor.cyan
    
    titleLabel.frame = CGRect(x: titleX, y: 0.0, width: titleW, height: btnWidth)
  }
}

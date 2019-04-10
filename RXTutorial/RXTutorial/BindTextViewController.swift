
import UIKit
import RxSwift
import RxCocoa

class BindTextViewController: UIViewController {
  
  @IBOutlet weak var textField001: UITextField!
  @IBOutlet weak var textField002: UITextField!
  @IBOutlet weak var labelTetx: UILabel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    //bindTextField()
    
//    behaviorSubjectTest()
//    variableSubjectTest()
//    publishSubjectTest()
//    replaySubjectTest()
//    operMap()
//    operFilter()
//    operMerge()
    operCombineLatest()
  }
  
  //MARK: - BindText
  func bindTextField() {
    textField001.rx.text
      .asObservable()
      .bind(to: textField002.rx.text)
      .disposed(by: disposeBag)
    
    textField001.rx.text
      .asObservable()
      .bind(to: labelTetx.rx.text)
      .disposed(by: disposeBag)
  }
  
  //MARK: - Behavior Subject
  //Behavior Subject เมื่อทำการ Subscribe แล้วทำงานถึงทุกตัวที่ทำการ Subscribe
  func behaviorSubjectTest() {
    
    let tEXT = "jOKER Bear"
    let tEXT2 = "Lolipop"
    let arr = ["123","123","123","123","123","123","123","855858"]
    
    let bSubject = BehaviorSubject(value: arr)
    //ถ้า Value ตอนแรกที่สร้างเป็นชนิดแบบไหน ตัว onNext ที่จะใส่ต่าอไปก็จะต้องใส่ เป็นชนิดนั้นด้วย
    
    let sub1 = bSubject.subscribe(onNext: {(value) in
      print("sub1 onNext : \(value)")
    }, onError: {(error) in
      print("sub2 onError : \(error)")
    })
    
    bSubject.onNext([tEXT])
    
    let sub2 = bSubject.subscribe(onNext: {(value) in
      print("sub2 onNext : \(value)")
    }, onError: {(error) in
      print("sub2 onError : \(error)")
    })
    
    bSubject.onNext([tEXT2])
    
    //Print Value in bSubject.value
    do{
      try print("bSubject.value : \(bSubject.value())")
    }catch{
      print("Found Error: \(error.localizedDescription)")
    }
  }
  
  //MARK: - Variable Subject
  //หลักการทำงานเหมือน Behavior Subject แต่ทำให้ดูใช้งานง่ายมากกว่า Behavior Subject
  func variableSubjectTest() {
    let str = ["A","B","C","D","E","F","G"]
    
    let vSubject = Variable<Int>(0)
    
    let vSubscribe1 = vSubject.asObservable()
      .subscribe(onNext: {(value) in
        print("vSub1 onNext : \(value)")
      }, onError: {(error) in
        print("vSub1 Error : \(error)")
      })
    
    vSubject.value = 3
    
    let vSubscribe2 = vSubject.asObservable()
      .subscribe(onNext: {(value) in
        print("vSub2 onNext : \(value)")
      }, onError: {(error) in
        print("vSub2 Error : \(error)")
      })
    
    vSubject.value = 4
    
    let vSubscribe3 = vSubject.asObservable()
      .subscribe(onNext: {(value) in
        print("vSub3 onNext : \(value)")
        }, onError: {(error) in
          print("vSub3 Error : \(error)")
        })
  }
  
  //MARK: - PublishSubject
  //การทำงานของ Publish Subject จะทำงานกับตัวที่ทำการ Subscribe ไว้ก่อนหน้าเท่านั้น ถ้ามีการ Subscribe ไว้หลังตัว onNext ก็จะไม่ทำงาน
  func publishSubjectTest() {
    let pSubject = PublishSubject<Int>()
    
    pSubject.onNext(0)
    
    let pSubscibe1 = pSubject.asObservable()
      .subscribe(onNext: {(value) in
        print("pSub1 onNext : \(value)")
      }, onError: {(error) in
        print("pSub1 Error : \(error)")
      })
    
    pSubject.onNext(1)
    
    let pSubscribe2 = pSubject.asObservable()
      .subscribe(onNext: {(value) in
        print("pSub2 onNext : \(value)")
      }, onError: {(error) in
        print("pSub2 Error : \(error)")
      })
    
    pSubject.onNext(2)
    
    let pSubscribe3 = pSubject.asObservable()
      .subscribe(onNext: {(value) in
        print("pSub3 onNext : \(value)")
      }, onError: {(error) in
        print("pSub3 Error : \(error)")
      })
    
    pSubject.onNext(3)
    
  }
  
  //MARK: - Replay Subject
  //Replay Subject จะทำการเก็บค่าไว้ตามจำนวนที่ใส่ bufferSize ไว้
  func replaySubjectTest() {
    let rSubject = ReplaySubject<Int>.create(bufferSize: 3)
    
    rSubject.onNext(0) // ค่าข้างใน rSubject จะมี 0 1 2 จำนวน 3 ค่า
    rSubject.onNext(1) // ค่าข้างใน rSubject จะมี 1 2 3 จำนวน 3 ค่า
    rSubject.onNext(2)
    
    let rSubscribe1 = rSubject.subscribe(onNext: {(value) in
      print("rSub1 onNext : \(value)")
    })
    
    rSubject.onNext(3)
    
    let rSubscribe2 = rSubject.subscribe(onNext: {(value) in
      print("rSub2 onNext : \(value)")
    })
  }
  
  //MARK: - Operator
  
  //MARK: - Map
  //Operator Map ทำการเปลี่ยนชนิดตัวแปรเป็นอีกชนิด เหมือนกับการ Casting
  func operMap() {
    let myStream = BehaviorSubject<Int>(value: 0)
    
    let mapSubscribe = myStream
      .map{(value) -> String in
        return "Map String : \(value)"}
      .subscribe(onNext: {(value) in
        print ("onNext String : [\(value)]")
      })
  }
  
  //MARK: - Filter
  //Operator Filter ทำการกรองค่า ตามเงื่อนไข ที่ตั้งไว้ถ้าไม่ตรงตามเงื่อนไขกูจะหยุดการทำงาน
  func operFilter() {
    let myStream = BehaviorSubject<Int>(value: 0)
    
    let filterSubscribe = myStream
      .filter{ (value) -> Bool in     //เช็คว่า onNext ที่เข้ามา มีค่ามากกว่า 2 มั้ย ถ้ามากกว่า ก็จะส่ง True กลับไปและ ทำขั้นอื่นต่อ
        return value > 2 }
      .map{(value) -> String in       //Map ทำการเปลี่ยน Int ให้เป็น String และ Return ค่าออกไปเป็นข้อความ
        return "My String : \(value)" }
      .subscribe(onNext: {(value) in  //Subscribe ทำการทำงานเอาค่า Value ที่ได้มาใช้
        print("\(value)")
      })
    
    myStream.onNext(1)
    myStream.onNext(2)
    myStream.onNext(3)
    myStream.onNext(50)
  }
  
  //MARK: - Merge
  //Operator Merge ตัวนี้จะทำการ Merge ทุกครั้งที่ onNext เข้ามาตามเส้นที่อยู่ข้างใน asObserver() ถ้าจะ Merge ได้ ต้องเป็น Type เดียวกัน
  func operMerge() {
    let myStream = BehaviorSubject<Int>(value: 0)
    let secondStream = BehaviorSubject<Int>(value: 100)
    
    let mergedSubscribe = Observable.merge([
        myStream.asObserver(),
        secondStream.asObserver()
      ]).subscribe(onNext : {(value) in
        print("On Next : [\(value)]")
      })
    
    myStream.onNext(1)
    secondStream.onNext(99)
    secondStream.onNext(98)
    secondStream.onNext(97)
    myStream.onNext(2)
    myStream.onNext(3)
    
  }
  
  //MARK: - CombineLatest
  //Operator CombineLatest - ทำการ Combine เมื่อ 
  func operCombineLatest() {
    let myStream = BehaviorSubject<Int>(value: 0)
    let messageStream = BehaviorSubject<String>(value: "AA")
    
    let conbineSubscribe = Observable.combineLatest(myStream, messageStream)
    { (valueOfMyStream, valueOfMessageStream) -> String in
      return "MyStream \(valueOfMyStream) | MyMessageStream \(valueOfMessageStream)"
    }
      .subscribe(onNext: {(value) in
        print("On Next : \(value)")
      })
    
    messageStream.onNext("BB")
    myStream.onNext(1)
    myStream.onNext(2)
    myStream.onNext(3)
    messageStream.onNext("CC")
    myStream.onNext(4)
    
  }
  
}

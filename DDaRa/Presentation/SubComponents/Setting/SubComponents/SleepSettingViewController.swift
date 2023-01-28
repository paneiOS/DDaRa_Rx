//
//  SleepSettingViewController.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/25.
//

import UIKit

struct SleepSettingAction {
    let showSleepSettingViewController: () -> Void
}

final class SleepSettingViewController: UIViewController {
    private let timer: RepeatingTimer
    private var time = 0
    var pause: (() -> Void)!
    
    private lazy var countDownDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()
    
    private lazy var confirmTimerSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(didTapRepeatTimerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelTimerButton: UIButton = {
        let button = UIButton()
        button.setTitle("해제", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(didTapCancelTimerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var remainTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var minuteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        [remainTime, hourLabel, minuteLabel, secondLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    init(timer: RepeatingTimer) {
        self.timer = timer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
    }
    
    private func setupLayout() {
        [countDownDatePicker, confirmTimerSettingButton, cancelTimerButton, timeStackView].forEach {
            view.addSubview($0)
        }
        
        countDownDatePicker.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        confirmTimerSettingButton.snp.makeConstraints {
            $0.top.equalTo(countDownDatePicker.snp.bottom).offset(20)
            $0.centerX.equalToSuperview().offset(-40)
        }
        
        cancelTimerButton.snp.makeConstraints {
            $0.top.equalTo(countDownDatePicker.snp.bottom).offset(20)
            $0.centerX.equalToSuperview().offset(40)
        }
        
        timeStackView.snp.makeConstraints {
            $0.top.equalTo(confirmTimerSettingButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    private func setupAttribute() {
        title = "자동종료 설정"
        view.backgroundColor = .white
    }
    
    @objc func didTapRepeatTimerButton() {
        startRepeatTimer()
        setTimerButtonsUsingTimerState()
    }

    @objc func didTapResumeRepeatTimerButton() {
        timer.resume()
        setTimerButtonsUsingTimerState()
    }

    @objc func didTapSuspendTimerButton() {
        timer.suspend()
        setTimerButtonsUsingTimerState()
    }

    @objc func didTapCancelTimerButton() {
        timer.cancel()
        setTimerButtonsUsingTimerState()
    }

    private func setTimerButtonsUsingTimerState() {
        switch timer.timerState {
        case .resumed:
            return
        case .suspended:
            return
        case .canceled:
            remainTime.text = ""
            hourLabel.text = ""
            minuteLabel.text = ""
            secondLabel.text = ""
        case .finished: break
        }
    }
    
    private func startRepeatTimer() {
        let countDownTime = countDownDatePicker.countDownDuration
        timer.time = Int(countDownTime)
        timer.start(durationSeconds: countDownTime) {
            DispatchQueue.main.async { [weak self] in
                self?.timer.time -= 1
                let remainTime = self?.timer.time ?? 0
                
                if remainTime >= 3600 {
                    self?.hourLabel.text = "\(remainTime.hour) 시간"
                } else {
                    self?.hourLabel.text = ""
                }
                
                if remainTime >= 60 {
                    self?.minuteLabel.text = "\(remainTime.minute) 분"
                } else {
                    self?.minuteLabel.text = ""
                }
                
                if remainTime > 0 {
                    self?.remainTime.text = "남은시간 "
                    self?.secondLabel.text = "\(remainTime.seconds) 초"
                } else {
                    self?.remainTime.text = ""
                    self?.secondLabel.text = ""
                }
            }
        } completion: {
            DispatchQueue.main.async { [weak self] in
                self?.pause()
            }
        }
    }
}

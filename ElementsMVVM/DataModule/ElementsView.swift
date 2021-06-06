//
//  ViewController.swift
//  PryanikMVVM
//
//  Created by Владимир on 03.02.2021.
//

import UIKit

class ElementsViewController: UIViewController {
    weak var viewModel: ElementsViewModel! {
        didSet {
            viewModel.getDataFromServer {
                self.makeStackElements()
            }
        }
    }
    
    let stackView = UIStackView()
    let tappedElementLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        makeView()
    }
    
    private func makeView() {
        tappedElementLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        tappedElementLabel.text = viewModel.tappedElementText
        tappedElementLabel.lineBreakMode = .byWordWrapping
        tappedElementLabel.numberOfLines = 0
        tappedElementLabel.textAlignment = .center
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(tappedElementLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            tappedElementLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tappedElementLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            tappedElementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tappedElementLabel.bottomAnchor.constraint (equalTo: view.topAnchor, constant: 120),
            tappedElementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: tappedElementLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func makeStackElements() {
        
        let serverData = viewModel.serverData!
        
        for view in serverData.view {
            
            switch view {
            case "hz":
                guard let elementData = viewModel.getElementData(for: "hz") else {
                    break
                }
                let label = makeLabel(with: elementData)
                stackView.addArrangedSubview(label)
            case "selector":
                guard let elementData = viewModel.getElementData(for: "selector") else {
                    break
                }
                let selector = makeSelector(with: elementData)
                stackView.addArrangedSubview(selector)
            case "picture":
                guard let elementData = viewModel.getElementData(for: "picture") else {
                    break
                }
                let imageView = makeImage(with: elementData)
                stackView.addArrangedSubview(imageView)
            default:
                print("Unknown view")
            }
        }
    }
    
    private func makeLabel(with data: DataDescription) -> UILabel {
        let label = UILabel()
        
        label.text = data.text
        let labelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTapRecognizer)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func makeSelector(with data: DataDescription) -> UISegmentedControl {
        let selector = UISegmentedControl()
        
        let variants = data.variants!
        for index in 0..<variants.count {
            let action = UIAction(title: variants[index].text) { action in
                self.viewModel.setTappedElementText(with: variants[index].text) { (text) in
                    self.tappedElementLabel.text = text
                }
            }
            selector.insertSegment(action: action, at: index, animated: true)
        }
        
        let selectedId = data.selectedId!
        if selectedId <= selector.numberOfSegments, selectedId >= 0 {
            selector.selectedSegmentIndex = selectedId
        }
        
        selector.selectedSegmentIndex = data.selectedId!
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        return selector
    }
    
    private func makeImage(with data: DataDescription) -> UIImageView {
        let imageView = UIImageView()
        
        viewModel.getImageFromServer(url: data.url!) { imageData in
            imageView.image = UIImage(data: imageData)
        }
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapRecognizer)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer, text: String) {
        if sender.view is UIImageView {
            viewModel.setTappedElementText(with: "Нажата картинка") { (text) in
                self.tappedElementLabel.text = text
            }
        } else {
            viewModel.setTappedElementText(with: "Нажат текстовый блок") { (text) in
                self.tappedElementLabel.text = text
            }
        }
    }
}


//
//  SearchBar.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//


import SwiftUI


struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder() // Закриває клавіатуру
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        
        searchBar.placeholder = "Search breeds..."
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = UIColor.systemPink
        
        searchBar.backgroundImage = UIImage()
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Nohemi-Medium", size: 16)
            textField.backgroundColor = UIColor.systemGray6
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            
            textField.enablesReturnKeyAutomatically = false
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.systemPink
            }
        }
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

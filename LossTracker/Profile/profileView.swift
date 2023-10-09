//
//  profileView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/8/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage


struct profileView: View {
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        ZStack {
            Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Image("pokerBackground")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Image("defaultProfilePicture")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        }
                    }
                }

                HStack {
                    Text("First Name")
                    Text("Last Name")
                }
                .font(.title2)
                .padding()

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 300, height: 100)
                    .overlay(
                        VStack {
                            Text("Lifetime Stats")
                                .bold()
                            HStack {
                                Text("Total Winnings: $0")
                                Spacer()
                                Text("Total Games Played: 0")
                            }
                        }
                        .padding()
                    )
                    .padding()

                NavigationLink(destination: GameHistoryView()) {
                    Text("View Game History")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented, content: {
                ImagePicker(image: $profileImage)
            })
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    profileView()
}

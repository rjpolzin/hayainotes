import SwiftUI
import SwiftData
import UIKit

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var note: Note

    @State private var showingShareSheet = false

    var body: some View {
        ZStack {
            Color(red: 200/255, green: 200/255, blue: 200/255)
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        Text("TITLE")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))

                        TextField("Enter title", text: $note.title)
                            .padding()
                            .background(Color(red: 224/255, green: 240/255, blue: 141/255))
                            .cornerRadius(14)
                            .font(.system(size: 22))

                        Text("CONTENT")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))

                        GreenTextEditor(text: $note.content)
                            .frame(height: 380)
                    }
                    .padding()
                }

                Spacer()

                HStack(spacing: 34) {

                    BottomActionButton(
                        icon: "xmark",
                        label: "CANCEL",
                        bg: Color(red: 153/255, green: 0/255, blue: 51/255)
                    ) {
                        dismiss()
                    }

                    BottomActionButton(
                        icon: "paperplane.fill",
                        label: "SEND",
                        bg: Color(red: 0/255, green: 38/255, blue: 89/255)
                    ) {
                        showingShareSheet = true
                    }

                    BottomActionButton(
                        icon: "checkmark",
                        label: "SAVE",
                        bg: Color(red: 153/255, green: 0/255, blue: 51/255)
                    ) {
                        dismiss()
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingShareSheet) {
            ActivityView(activityItems: ["\(note.title)\n\n\(note.content)"])
        }
    }
}

struct BottomActionButton: View {
    let icon: String
    let label: String
    let bg: Color
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button(action: action) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.blue)
                    .frame(width: 70, height: 70)
                    .background(bg)
                    .clipShape(Circle())
                    .shadow(radius: 8)
            }

            Text(label)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))
        }
    }
}

struct GreenTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.backgroundColor = UIColor(
            red: 224/255,
            green: 240/255,
            blue: 141/255,
            alpha: 1
        )
        tv.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
        tv.textColor = .black
        tv.layer.cornerRadius = 14
        tv.delegate = context.coordinator
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context)
    -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}

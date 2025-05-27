import SwiftUI
import SwiftData
import UIKit

struct NoteDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var note: Note
    @State private var showingShareSheet = false

    var body: some View {
        ZStack {
            // Dirty gray background
            Color(red: 200/255, green: 200/255, blue: 200/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom header with Save and Cancel buttons
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color(red: 153/255, green: 0/255, blue: 51/255))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }

                    Spacer()

                    Button(action: { dismiss() }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color(red: 153/255, green: 0/255, blue: 51/255))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    .disabled(note.title.isEmpty || note.content.isEmpty)
                }
                .padding()
                .background(Color(red: 200/255, green: 200/255, blue: 200/255))

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Title")
                            .font(.headline)
                            .padding(.horizontal)

                        ZStack {
                            Color(red: 224/255, green: 240/255, blue: 141/255)
                                .cornerRadius(8)
                                .shadow(radius: 1)

                            TextField("Title", text: $note.title)
                                .foregroundColor(.black)
                                .padding(8)
                                .background(Color.clear)
                        }
                        .padding(.horizontal)

                        Text("Content")
                            .font(.headline)
                            .padding(.horizontal)

                        GreenTextEditor(text: $note.content)
                            .frame(height: 200)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarHidden(true) // Hide the default nav bar to show custom header
        .sheet(isPresented: $showingShareSheet) {
            ActivityView(activityItems: [shareText()])
        }
        .colorScheme(.light)
    }

    private func shareText() -> String {
        "\(note.title)\n\n\(note.content)"
    }
}

// UIKit wrapper for UITextView with custom muted green background
struct GreenTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor(red: 224/255, green: 240/255, blue: 141/255, alpha: 1)
        textView.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .regular)
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.textColor = UIColor.black
        return textView
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

// UIKit wrapper for share sheet
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


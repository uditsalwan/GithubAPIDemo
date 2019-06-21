# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def rx_swift
    pod 'RxSwift'
    pod 'RxCocoa'
end

target 'GithubIssueViewer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GithubIssueViewer
    rx_swift
    pod 'ObjectMapper'
    pod 'Alamofire'
    pod 'AlamofireNetworkActivityLogger'	

  target 'GithubIssueViewerTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# Midia

Midia is an application who allow you to see, search and save as favorite, books from Google API and movies from iTunes API.

## Instalation

### Google API key

To run this app, you must to **rename `info_example.plist`** file inside the folder Midia to **`info.plist`** and in the key *GoogleAPIAccessKey* insert an valid Google API key.

```
<key>GoogleAPIAccessKey</key>
<string>Your Google API Access Key</string>
```
### CocoaPods

To run this app, you must to execute the following command from the terminal to install CocoaPods dependencies:

`pod install`
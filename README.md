RRSenderPhoto plugin for Mac Mail
=========

Mac mail for Lion has a very nice feature to show photos of sender from address book, but i get a lot of spam from services like google and podio, and don't want to add them to address book.

How to install:
---------
1) copy Release/RRSenderPhoto.mailbundle to ~/Library/Mail/Bundles/<br>
2) enable plugins support, in terminal:<br>
&nbsp;&nbsp;defaults write com.apple.mail EnableBundles -bool true<br>
&nbsp;&nbsp;defaults write com.apple.mail BundleCompatibilityVersion 3<br>
3) restart Mail.app

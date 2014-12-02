#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
          install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity.png"
                    install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity@2x.png"
                    install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity@2x~ipad.png"
                    install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity~ipad.png"
                    install_resource "ARSafariActivity/ARSafariActivity/ARSafariActivity-iPad.png"
                    install_resource "ARSafariActivity/ARSafariActivity/ARSafariActivity-iPad@2x.png"
                    install_resource "ARSafariActivity/ARSafariActivity/ARSafariActivity@2x.png"
                    install_resource "ARSafariActivity/ARSafariActivity/cs.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/da.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/de.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/en.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/es-ES.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/es.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/fr.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/it.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/ja.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/ko.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/nb.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/nl.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/ru.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/sk.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/sv.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/vi.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/zh-Hans.lproj"
                    install_resource "ARSafariActivity/ARSafariActivity/zh-Hant.lproj"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/clip.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/clip@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/clip@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/play.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/play@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/play@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@2x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@3x.png"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_received.aiff"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_sent.aiff"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Controllers/JSQMessagesViewController.xib"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellIncoming.xib"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellOutgoing.xib"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesLoadEarlierHeaderView.xib"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesToolbarContentView.xib"
                    install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesTypingIndicatorFooterView.xib"
                    install_resource "TWMessageBarManager/Classes/Icons/icon-error.png"
                    install_resource "TWMessageBarManager/Classes/Icons/icon-error@2x.png"
                    install_resource "TWMessageBarManager/Classes/Icons/icon-info.png"
                    install_resource "TWMessageBarManager/Classes/Icons/icon-info@2x.png"
                    install_resource "TWMessageBarManager/Classes/Icons/icon-success.png"
                    install_resource "TWMessageBarManager/Classes/Icons/icon-success@2x.png"
          
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi

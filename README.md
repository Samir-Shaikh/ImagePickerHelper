# ImagePickerHelper
Picke image from gallery and camera easily.

Just drag this file in project and use it easily.
using this its very easy to pick images and video from gallery or camera.

use it like below.

//for image picker
ImagePickerHelper.shared.openImagePicker(for: self) { (image) in

    print(image)
}

//for video picker
ImagePickerHelper.shared.openVideoPicker(for: self) { (url) in
                
    print(url)
}

# Tire Stud Detection Using MATLAB

## 1. Objective

The purpose of this project is to detect possible metal studs on tire images using MATLAB image processing techniques.

The program analyzes two images:
- Studded tire
- Summer tire

It uses image preprocessing, thresholding, morphological operations, and connected-component analysis to classify the tires.

## 2. Methodology

The detection process contains the following steps:

1. **Read images:** Load both tire images and resize them to 50% of their original size.
2. **Grayscale conversion:** Convert RGB images into grayscale images.
3. **Tire mask:** Use intensity thresholding to isolate the dark tire area.
4. **Candidate detection:** Identify bright regions inside the tire mask as possible studs.
5. **Noise removal:** Apply morphological operations to remove small noise and clean the candidate regions.
6. **Connected components:** Use `bwconncomp()` and `regionprops()` to analyze the detected regions.
7. **Classification:** Count the possible studs and classify the tire using a threshold of 30.

## 3. MATLAB Techniques Used

| Function | Purpose |
|---|---|
| `imread()` | Read tire images |
| `imresize()` | Resize images |
| `rgb2gray()` | Convert RGB to grayscale |
| `imfill()` | Fill holes in the mask |
| `bwareaopen()` | Remove small objects |
| `imopen()` | Remove small noise |
| `imclose()` | Connect nearby regions |
| `bwconncomp()` | Find connected components |
| `regionprops()` | Measure component properties |
| `visboundaries()` | Display detected regions |

## 4. Results

The MATLAB program produced the following results:

| Image | Detected possible studs | Classification |
|---|---:|---|
| Studded tire | 58 | STUDDED TIRE |
| Summer tire | 19 | NON-STUDDED TIRE |

The classification threshold was set to 30.

The studded tire had 58 detected possible studs, which is above the threshold. Therefore, it was classified as a studded tire.

The summer tire had 19 detected possible studs, which is below the threshold. Therefore, it was classified as a non-studded tire.

## 5. Observations

The program successfully distinguished between the two provided tire images.

The candidate mask showed bright regions inside the tire area. Connected-component analysis helped identify possible stud locations.

The results depend on image brightness, tire texture, and the selected threshold values. Some tire patterns may also be detected as possible studs.

Therefore, the detected count represents possible studs and not a guaranteed count of physical metal studs.

## 6. Limitations

- The program uses fixed intensity thresholds.
- Tire lighting and image quality can affect detection.
- Tire patterns may produce false detections.
- The classification threshold was selected based on the two provided images.
- More tire images are needed to evaluate the accuracy of the method.

## 7. Conclusion

This project demonstrates how MATLAB image processing can be used for simple tire stud detection.

The combination of grayscale conversion, thresholding, morphological operations, and connected-component analysis produced different detection counts for the two provided tire images.

The program classified the studded tire and summer tire correctly in this experiment.


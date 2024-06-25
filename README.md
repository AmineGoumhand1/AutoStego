# AutoStegano

AutoStegano is a Bash script designed to automate the process of analyzing images for steganography. It utilizes various tools such as `strings`, `exiftool`, `zsteg`, `outguess`, `binwalk`, `steghide`, and `stegsolve` to extract and analyze hidden information from images.

## Features

- Checks file extension and basic file information using `file`
- Extracts long significant strings using `strings`
- Displays metadata using `exiftool`
- Uses `zsteg` to analyze least significant bits (LSB) steganography
- Utilizes `outguess` to extract hidden information
- Extracts data using `binwalk`
- Performs steganography extraction using `steghide`
- Provides an option to run `stegsolve` for further analysis

## Prerequisites

- Linux environment
- Required tools: `strings`, `exiftool`, `zsteg`, `outguess`, `binwalk`, `steghide`, `java` (for `stegsolve`)
- Install `stegsolve` by downloading the JAR file from [here](http://www.caesum.com/handbook/Stegsolve.jar)

## Installation

```bash
sudo apt-get install -y strings exiftool steghide zsteg outguess binwalk default-jre

## Usage

```bash
./autostegano.sh <image_file> <patternToLookFor> <steghidePassword>

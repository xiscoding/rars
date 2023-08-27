# rars

## Installation

### Step 1: Install Java
- run java --version
- Java 8, Java 11, and Java 17 have been tested and are known to work with RARS
- IF you dont have java :
	- https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-do-I-install-Java-on-Ubuntu#:~:text=While%20Ubuntu%20does%20not%20come,Java%20with%20the%20apt%20command.
	- sudo apt install default-jdk
- check install 
	- java --jar 

### Step 2: Install RARS
- Option 1: clone this repo it has the .jar file
- RARS is a RISC-V assembler 
- Its possible the .jar included in this repo is not up to date
- Do the below to ensure the RARS version is the most recent
- https://github.com/TheThirdOne/rars/releases 
	- Scroll down to assets
	- Download
- Run the `.jar` file using Java - `java -jar <path_to_rars.jar>`

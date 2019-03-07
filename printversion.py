import platform
import subprocess

javaVersion = subprocess.check_output(['java', '-version'], stderr=subprocess.STDOUT)

print("----------------------")
print("Welkam Bosque!")
print("----------------------\n")

print("Python version is: \n")
print(platform.python_version())
print("\n")

print("Java version: \n")
print(javaVersion)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#define TEST_NUMBERS 6
#define TEST_SCORE 15
#define INITIAL_SCORE 10

#define MALLOC_CONSTANT 5000

char* concat(int n, ...) 
{
	va_list(lp);
	va_start(lp, n);

	char* result = (char*)malloc(n*MALLOC_CONSTANT);
	memset(result, 0, n*10);
	for (int i = 0; i < n; ++i)
	{
		char* nextStringItem = va_arg(lp, char*);
		strcat(result, nextStringItem);
	}
	
	va_end(lp);
	
	return result;
}

int isSpecialDirectory(char *name)
{
	if (strcmp(name, ".") == 0 || strcmp(name, "..") == 0)
	{
		return 1;
	}
	return 0;
}

int isDirectory(char *name)
{
	struct stat info;
	stat (name, &info);
	return S_ISDIR(info.st_mode);
}

char* createCommand(char* input, char* problemNumber, char* sourceFile)
{
	for (int i = 0; i < strlen(input); ++i)
	{
		if (input[i] == '\n') 
		{
			input[i] = 0;
		}
	}
	
	char* modifiedInput = (char*) malloc(MALLOC_CONSTANT);
	memset(modifiedInput, 0, MALLOC_CONSTANT);
	
	for (int i = 0; i < strlen(input); ++i)
	{
		if (input[i] != ' ')
		{
			char str[15];
			sprintf(str, "%c", input[i]);
			strcat(modifiedInput, str);
		}
		else 
		{
			strcat(modifiedInput, " \\ ");
		}
	}
	
	char* command = concat(3, "printf '%s\\n' \\ ", modifiedInput, " | ./hw > tempOutput.txt");
	return command;
}

char* tempResult()
{
	FILE *f = fopen("tempOutput.txt", "r");
	char* buffer = (char*)malloc(MALLOC_CONSTANT);
	char* result = (char*)malloc(MALLOC_CONSTANT);
	memset((void*) result, 0, MALLOC_CONSTANT);
	while (fgets(buffer, 1000, f) != NULL)
	{
		for (int i = 0; i < strlen(buffer); ++i)
		{
			if (buffer[i] == '\n') 
			{
				buffer[i] = 0;
			}
		}
		
		result = concat(3, result, buffer, " ");
	}
	
	fclose(f);
	return result;
}

void evaluateSource(char* testNumberStr, char* assemblySource)
{
	int testNumber = atoi(testNumberStr);
	printf("Processing %s...\n", assemblySource);
	
	char inputs[TEST_NUMBERS][100];
	
	int res = 0;
	for (int inputCounter = 0; inputCounter < TEST_NUMBERS; ++inputCounter) 
	{
		char counterNumber[15];
		sprintf(counterNumber, "%d", inputCounter);
		char* inputFileName = concat(4, "in", testNumberStr, counterNumber, ".txt");
		char* outputFileName = concat(4, "out", testNumberStr, counterNumber, ".txt");
		
		printf("test %d: ", inputCounter);
		chdir("../tests"); chdir(testNumberStr);
		
		FILE *inFile = fopen(inputFileName, "r");
		FILE *outFile = fopen(outputFileName, "r");

		char *bufferIn = (char*)malloc(MALLOC_CONSTANT);
		char *bufferOut = (char*)malloc(MALLOC_CONSTANT);
		
		char *lineInput = fgets(bufferIn, MALLOC_CONSTANT, inFile);

		char *command = createCommand(lineInput, testNumberStr, assemblySource);
		
		char *realResult = (char*)malloc(MALLOC_CONSTANT);
		memset((void*) realResult, 0, MALLOC_CONSTANT);
		
		while (fgets(bufferOut, MALLOC_CONSTANT, outFile) != NULL)
		{
			for (int i = 0; i < strlen(bufferOut); ++i)
			{
				if (bufferOut[i] == '\n')
				{
					bufferOut[i] = 0;
				}
			}
			realResult = concat(3, realResult, bufferOut, " ");
		}
		
		
		chdir("..");
		chdir("../sourcesx86");
		
		char* intermediateCommand = concat(3, "as --32 ", assemblySource, " -o hw.o");
		system(intermediateCommand);
		system("gcc -m32 hw.o -o hw");
		system(command);
	
		char *evaluation = tempResult();
		
		if (!strcmp(evaluation, realResult)) 
		{
			printf("%s\n", "ok");
			res += TEST_SCORE;
		}
		else 
		{
			printf("%s", "fail");
			printf("\n--- Test details:\n------ input: %s\n------ expected: %s\n------ your output: %s\n",
				lineInput, realResult, evaluation);
		}

		free(evaluation);
		free(command);
		free(bufferIn);
		free(bufferOut);
		free(inputFileName);
		free(outputFileName);
		free(realResult);
		fclose(inFile);
		fclose(outFile);
	}
	
	printf("Result: %d / %d\n", res + INITIAL_SCORE, TEST_NUMBERS * TEST_SCORE + INITIAL_SCORE);
	
	chdir("..");
	char* evaluationResultString = (char*)malloc(MALLOC_CONSTANT);
	sprintf(evaluationResultString, "%d", res + INITIAL_SCORE);
	char* writeResult = concat(5, "printf \"", assemblySource, ": ", 
		evaluationResultString, "\n\" >> resultsx86.txt");
	free(evaluationResultString);
	system(writeResult);
	chdir("sourcesx86");
}


void evaluateInDirectory(char *directoryName, char *testNumber)
{

	DIR* directory;
	struct dirent* entry;
	
	directory = opendir (directoryName);
	
	if (directory == NULL) 
	{
		puts ("This directory does not exist");
		return;
	}
	
	chdir (directoryName);
	
	while ((entry = readdir(directory)) != NULL)
	{
		if (isSpecialDirectory(entry->d_name) || isDirectory(entry->d_name))
		{
			continue;
		}
		
		struct stat info;
		stat(entry->d_name, &info);
		if (S_ISREG(info.st_mode))
		{
			printf("%s\n", entry->d_name);
			evaluateSource(testNumber, entry->d_name);
			system("rm tempOutput.txt");
			system("rm hw.o");
			system("rm hw");
		}
	}
	chdir("..");
	closedir(directory);
}

int main(int argc, char* argv[])
{
	if (argc != 2) 
	{
		printf("%s\n", "Invalid number of arguments");
		return -1;
	}
	
	//evaluateSource(argv[1], argv[2]);
	evaluateInDirectory("sourcesx86", argv[1]);
	
	return 0;
}

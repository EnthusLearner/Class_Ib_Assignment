# ==================================================== 
# Assignment 2 - Differential Gene Expression Analysis
# ====================================================

# 1. Install & Load necessary package 
install.packages("downloader")  
library(downloader)

# 2. Store urls and file names
file_urls  <- c(
  "https://raw.githubusercontent.com/AI-Biotechnology-Bioinformatics/AI_and_Omics_Research_Internship_2025/refs/heads/main/DEGs_Data_1.csv",
  "https://raw.githubusercontent.com/AI-Biotechnology-Bioinformatics/AI_and_Omics_Research_Internship_2025/refs/heads/main/DEGs_Data_2.csv"
)
file_names <- c("DEGs_data_1.csv", "DEGs_data_2.csv")

# 3. Download the files (loop for each file)
for (i in seq_along(file_urls)) {
  download(file_urls[i], destfile = file_names[i])
}

# 4. Set working directory 
base_dir <- "C:/AI_and_Omics_Internship_2025/Module_I_class_2"

# Create base folder if it doesn't exist
if (!dir.exists(base_dir)) dir.create(base_dir, recursive = TRUE)

# Set working directory
setwd(base_dir)
getwd()  

# 5. Define folder structure
input_dir  <- "Raw_data"     # where raw CSVs will be stored
clean_dir  <- "Clean_data"   # optional cleaned datasets
script_dir <- "Scripts"      # for saving your R scripts
output_dir <- "Results"      # final processed files

# Create subfolders if they don’t exist
dirs <- c(input_dir, clean_dir, script_dir, output_dir)
for (d in dirs) {
  if (!dir.exists(d)) dir.create(d)
}

# 6. Prepare empty list to store results
files_to_process <- c("DEGs_data_1.csv", "DEGs_data_2.csv") 
result_list <- list()

# 7. Define classify_gene function
classify_gene <- function(logFC, padj) {
  ifelse (padj < 0.05 & logFC < -1, "Downregulated",
          ifelse (padj < 0.05 & logFC > 1, "Upregulated",
                  "Not Significant"))
}

# 8. Process each file in a loop
for (files in files_to_process) {
  cat("\nProcessing:", files, "\n")
  file_path <- file.path(input_dir, files)
  data <- read.csv(file_path, header = TRUE)
  cat("File imported! Checking for missing values...\n")
  
  # Handle missing padj values
  if ("padj" %in% names(data)) {
    missing_count <- sum(is.na(data$padj))
    cat("Missing values in padj column:", missing_count, "\n")
    data$padj[is.na(data$padj)] <- mean(data$padj, na.rm = TRUE)
  }
  
  # Handle missing logFC values
  if ("logFC" %in% names(data)) {
    missing_values <- sum(is.na(data$logFC))
    cat("Missing values in logFC:", missing_values, "\n")
    data$logFC[is.na(data$logFC)] <- mean(data$logFC, na.rm = TRUE)
  }
  
  # Classify genes
  data$Gene_Class <- mapply(classify_gene, data$logFC, data$padj)
  cat("Genes have been classified successfully!\n")
  
  # Save results into list
  result_list[[files]] <- data
  
  # Save processed results into Results folder
  output_file_path <- file.path(output_dir, paste0("classification_", files))
  write.csv(data, output_file_path, row.names = FALSE)
  cat("Results saved to:", output_file_path, "\n")
  
  # Print summary counts
  gene_counts <- table(data$Gene_Class)
  cat("Summary counts for", files, ":\n")
  print(gene_counts)
  
  # (Optional) save cleaned data into Clean_data folder
  clean_file <- file.path(clean_dir, paste0("Clean_", files))
  write.csv(data, clean_file, row.names = FALSE)
}

# Save workspace
save.image(file = "GloriaSapra_Class_2_Assignment.RData")

# If you want quick access to results
result_1 <- result_list[[1]]
result_2 <- result_list[[2]]

# 9. Save a copy of this script into "Scripts" folder
script_copy_path <- file.path(script_dir, "Assignment2_DEG_Analysis.R")

# Save everything from this R session into that script file
writeLines(readLines("Assignment2_DEG_Analysis.R"), script_copy_path)

cat("\nScript has been saved into:", script_copy_path, "\n")

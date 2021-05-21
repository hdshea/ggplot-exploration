library(tidyverse)

# Individual geoms

df <- data.frame(
    x = c(3, 1, 5),
    y = c(2, 4, 6),
    label = c("a","b","c")
)

p <- ggplot(df, aes(x, y, label = label)) +
    labs(x = NULL, y = NULL) + # Hide axis label
    theme(plot.title = element_text(size = 12)) # Shrink plot title

# The point geom is used to create scatterplots.
# The scatterplot is most useful for displaying the relationship between two continuous variables.
p + geom_point() + ggtitle("point")

# geom_text() adds only text to the plot.
p + geom_text() + ggtitle("text")

# geom_label() draws a rectangle behind the text, making it easier to read (?).
p + geom_bar(stat = "identity") + ggtitle("bar")

# geom_tile() uses the center of the tile and its size (x, y, width, height)
# The most common use for rectangles is to draw a surface.
# On-line documentations says that geom_raster is the same but faster and preferred for PDF.
p + geom_tile() + ggtitle("raster")
p + geom_raster() + ggtitle("raster")

# geom_line() connects the observations in order of the variable on the x axis.
p + geom_line() + ggtitle("line")

# geom_path() connects the observations in the order in which they appear in the data.
p + geom_path() + ggtitle("path")

# geom_step() creates a stairstep plot, highlighting exactly when changes occur.
p + geom_step() + ggtitle("step")

# geom_area() displays a y interval defined by 0 and y.
p + geom_area() + ggtitle("area")

# geom_polygon() connects the observations in the order in which they appear in the data and connects the start and end points
# with the interior filled with the fill color.
p + geom_polygon() + ggtitle("polygon")

# Collective geoms

# Multiple groups, one aesthetic:  for cases where you want to separate data into groups, but render them in the same way.
# spaghetti plot for the growth trajectory (height by age) of each boy (Subject) in the study
data(Oxboys, package = "nlme")
ggplot(Oxboys, aes(age, height, group = Subject)) +
    geom_point() +
    geom_line()

# Different groups on different layers:  commonly, one layer might display individuals, while another displays an
# overall summary.  Note that a specific group parameter is used only on the geom_line layer.
# Since no group is specified on the geom_smooth layer, the group aesthetic is mapped to the interaction of all
# discrete variables in the plot, the default.
ggplot(Oxboys, aes(age, height)) +
    geom_line(aes(group = Subject)) +
    geom_smooth(method = "lm", size = 2, se = FALSE)

# Different reference frames for different variable types:

# One boxplot for each unique Ocassion across all Subjects.
ggplot(Oxboys, aes(Occasion, height)) +
    geom_boxplot()
# Adding in each individual Subject's growth trajectory - requires overriding the default grouping of the boxplot layer
ggplot(Oxboys, aes(Occasion, height)) +
    geom_boxplot() +
    geom_line(aes(group = Subject), color = "BLUE", alpha = 0.5)

# Matching aesthetics

# continuous versus discrete variables and aesthetic display
df <- data.frame(x = 1:3, y = 1:3, color = c(1,3,5))

# discrete - factor(color)
ggplot(df, aes(x, y, color = factor(color))) +
    geom_line(aes(group = 1), size = 2) +
    geom_point(size = 5)
# continuous - color
ggplot(df, aes(x, y, color = color)) +
    geom_line(aes(group = 1), size = 2) +
    geom_point(size = 5)

# Uncertainty and data range display

# assuming y conditional on x
y <- c(18, 11, 16)
df <- data.frame(x = 1:3, y = y, se = c(1.2, 0.5, 1.0))

base <- ggplot(df, aes(x, y, ymin = y - se, ymax = y + se))
base + geom_crossbar()
base + geom_pointrange()
base + geom_smooth(stat = "identity")

base + geom_errorbar()
base + geom_linerange()
base + geom_ribbon()

# for x conditional on y, use xmin and xmax and coord_flip()
base <- ggplot(df, aes(x, y, xmin = x - se, xmax = x + se))
base + geom_crossbar() +
    coord_flip()

# Showing weight of effects

# simple - size aesthetic
# Unweighted
ggplot(midwest, aes(percwhite, percbelowpoverty)) +
    geom_point()

# Weight by population
ggplot(midwest, aes(percwhite, percbelowpoverty)) +
    geom_point(aes(size = poptotal / 1e6)) +
    scale_size_area("Population\n(millions)", breaks = c(0.5, 1, 2, 4))

# more complicated - add weight aesthetic
# Unweighted
ggplot(midwest, aes(percwhite, percbelowpoverty)) +
    geom_point() +
    geom_smooth(method = lm, size = 1)

# Weighted by population
ggplot(midwest, aes(percwhite, percbelowpoverty)) +
    geom_point(aes(size = poptotal / 1e6)) +
    geom_smooth(aes(weight = poptotal), method = lm, size = 1) +
    scale_size_area(guide = "none")

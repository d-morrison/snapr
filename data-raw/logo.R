## Script to generate man/figures/logo.png from the SVG design.
## Uses only base-R packages (grDevices, grid, graphics).
## Run from the package root:  source("data-raw/logo.R")

library(grid)

## ── helpers ──────────────────────────────────────────────────────────────────

## Convert SVG-style coordinates (origin top-left) to grid native coords.
## W, H: SVG viewBox width / height (181, 209 for the standard hex sticker).
svg_x <- function(x, W = 181) x / W
svg_y <- function(y, H = 209) 1 - y / H   # flip y-axis

## Draw a polygon given two numeric vectors of SVG coords.
hex_poly <- function(xs, ys, fill, col = "#2A0000", lwd = 4) {
  grid.polygon(
    svg_x(xs), svg_y(ys),
    gp = gpar(fill = fill, col = col, lwd = lwd)
  )
}

## Approximate a cubic-bezier with many line segments (no Rcpp needed).
bezier_pts <- function(p0, p1, p2, p3, n = 60) {
  t  <- seq(0, 1, length.out = n)
  mt <- 1 - t
  x  <- mt^3 * p0[1] + 3 * mt^2 * t * p1[1] + 3 * mt * t^2 * p2[1] + t^3 * p3[1]
  y  <- mt^3 * p0[2] + 3 * mt^2 * t * p1[2] + 3 * mt * t^2 * p2[2] + t^3 * p3[2]
  list(x = x, y = y)
}

## Chain cubic bezier segments into a closed polygon (SVG "C" command path).
## Each row of `segs` is c(cx1,cy1, cx2,cy2, ex,ey).
bezier_path <- function(start, segs, extra_pts = NULL) {
  xs <- start[1]; ys <- start[2]
  cur <- start
  for (i in seq_len(nrow(segs))) {
    p  <- bezier_pts(cur, segs[i, 1:2], segs[i, 3:4], segs[i, 5:6])
    xs <- c(xs, p$x[-1]); ys <- c(ys, p$y[-1])
    cur <- segs[i, 5:6]
  }
  if (!is.null(extra_pts)) {
    xs <- c(xs, extra_pts[, 1]); ys <- c(ys, extra_pts[, 2])
  }
  list(x = xs, y = ys)
}

## ── image setup ──────────────────────────────────────────────────────────────

out_file <- "man/figures/logo.png"
png(out_file, width = 543, height = 627, bg = "transparent")   # 3× standard 181×209
grid.newpage()
pushViewport(viewport(width = 1, height = 1,
                      xscale = c(0, 1), yscale = c(0, 1)))

## ── hexagon ──────────────────────────────────────────────────────────────────

hx <- c(90.5, 175.4, 175.4, 90.5,   5.6,   5.6)
hy <- c( 6.5,  55.5, 153.5, 202.5, 153.5,  55.5)
hex_poly(hx, hy, fill = "#861414", col = "#2A0000", lwd = 5)

## ── pectoral fin ─────────────────────────────────────────────────────────────

pfin <- bezier_path(
  c(64, 91),
  rbind(
    c(60, 106,  63, 120,  71, 123),
    c(69, 112,  68, 101,  70,  93)
  )
)
grid.polygon(svg_x(pfin$x), svg_y(pfin$y),
             gp = gpar(fill = "#A81818", col = NA))

## ── dorsal fin ───────────────────────────────────────────────────────────────

dfin <- bezier_path(
  c(63, 69),
  rbind(
    c(70, 58,  81, 50,  91, 48),
    c(101, 46, 113, 50, 122, 57),
    c(129, 63, 133, 71, 134, 77),
    c(118, 72, 100, 71,  83, 71),
    c( 74, 70,  68, 69,  63, 69)
  )
)
grid.polygon(svg_x(dfin$x), svg_y(dfin$y),
             gp = gpar(fill = "#C02020", col = NA))

## Dorsal fin spines
spine_mat <- matrix(c(
  65, 69,  70, 57,
  76, 68,  82, 52,
  88, 67,  93, 48,
 101, 67, 106, 50,
 115, 70, 120, 58,
 126, 74, 130, 64
), ncol = 4, byrow = TRUE)
for (i in seq_len(nrow(spine_mat))) {
  grid.lines(
    svg_x(spine_mat[i, c(1, 3)]),
    svg_y(spine_mat[i, c(2, 4)]),
    gp = gpar(col = "#8A1212", lwd = 2.5)
  )
}

## ── anal fin ─────────────────────────────────────────────────────────────────

afin <- bezier_path(
  c(101, 119),
  rbind(
    c(108, 133, 110, 142, 106, 144),
    c(100, 141,  95, 132,  94, 122)
  )
)
grid.polygon(svg_x(afin$x), svg_y(afin$y),
             gp = gpar(fill = "#B82020", col = NA))

## ── main fish body ───────────────────────────────────────────────────────────

## Build path: cubic beziers + two L (line) commands for the tail forks.
body_segs_upper <- rbind(
  c(31,  76,  49,  67,  67,  67),
  c(83,  67, 109,  69, 130,  78),
  c(140, 82, 147,  87, 149,  91)
)
body_upper <- bezier_path(c(26, 93), body_segs_upper)

## Line to upper tail fork then bezier to notch, then to lower fork
notch_in  <- bezier_pts(c(163, 73), c(157, 88), c(155, 94), c(151, 96))
notch_out <- bezier_pts(c(151, 96), c(155, 99), c(157, 105), c(163, 119))

body_segs_lower <- rbind(
  c(147, 108, 140, 113, 128, 118),
  c(107, 126,  83, 127,  67, 125),
  c( 49, 123,  31, 114,  26, 101)
)
body_lower <- bezier_path(c(149, 104), body_segs_lower)

bx <- c(body_upper$x,
        163,          # L 163,73 (upper fork)
        notch_in$x[-1],
        notch_out$x[-1],
        body_lower$x, # starts with L 149,104
        26)           # close back to snout
by <- c(body_upper$y,
        73,
        notch_in$y[-1],
        notch_out$y[-1],
        body_lower$y,
        101)

## Colour approximation of the 3-stop gradient (use mid tone)
grid.polygon(svg_x(bx), svg_y(by),
             gp = gpar(fill = "#DC3A24", col = NA))

## Belly highlight
belly_segs <- rbind(
  c( 56, 121,  76, 126,  96, 126),
  c(116, 126, 136, 119, 148, 108),
  c(131, 117, 109, 123,  91, 123),
  c( 71, 123,  53, 117,  44, 105)
)
belly <- bezier_path(c(44, 105), belly_segs)
grid.polygon(svg_x(belly$x), svg_y(belly$y),
             gp = gpar(fill = "#F87060", col = NA, alpha = 0.45))

## ── gill cover arc ───────────────────────────────────────────────────────────

gill <- bezier_pts(c(62, 74), c(67, 87), c(67, 106), c(62, 119))
grid.lines(svg_x(gill$x), svg_y(gill$y),
           gp = gpar(col = "#A01515", lwd = 3, lineend = "round"))

## ── eye ──────────────────────────────────────────────────────────────────────

grid.circle(svg_x(45), svg_y(88), r = unit(9 / 181, "npc"),
            gp = gpar(fill = "white",   col = NA))
grid.circle(svg_x(46), svg_y(88), r = unit(6.5 / 181, "npc"),
            gp = gpar(fill = "#160606", col = NA))
grid.circle(svg_x(48), svg_y(86), r = unit(2.2 / 181, "npc"),
            gp = gpar(fill = "white",   col = NA))

## ── mouth ────────────────────────────────────────────────────────────────────

mouth_u <- bezier_pts(c(26, 89), c(32, 85), c(40, 85), c(46, 87))
mouth_l <- bezier_pts(c(26, 97), c(32, 101), c(40, 101), c(46, 99))
grid.lines(svg_x(mouth_u$x), svg_y(mouth_u$y),
           gp = gpar(col = "#7A0E0E", lwd = 3, lineend = "round"))
grid.lines(svg_x(mouth_l$x), svg_y(mouth_l$y),
           gp = gpar(col = "#7A0E0E", lwd = 2.5, lineend = "round"))

## ── text ─────────────────────────────────────────────────────────────────────

grid.text(
  "snapr",
  x = svg_x(90.5), y = svg_y(154),
  just = c("center", "bottom"),
  gp = gpar(
    fontfamily = "serif",
    fontsize   = 26 * 543 / 181,   # scale font for 3× PNG
    fontface   = "bold",
    col        = "white"
  )
)

dev.off()
message("Logo saved to ", out_file)

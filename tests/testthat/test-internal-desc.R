context("internal-desc")

describe("internal desc created", {
  it("bootstraps the fields correctly", {
    d <- create_internal_desc("test proj",
                         "devin pastoor",
                         "devin.pastoor@gmail.com")
    expect_equal(as.character(d$get_author()),
                 "devin pastoor <devin.pastoor@gmail.com> [aut, cre]")
    expect_equal(d$get_version(), package_version("0.0.1"))
    expect_equal(d$get_deps()$package, "magrittr")
  })
})

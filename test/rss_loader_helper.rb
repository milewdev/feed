def create_loader_that_loads(data_as_rss)
  rss_io = mock()
  rss_io.expects(:read).returns(data_as_rss)
  loader = RssLoader.new
  loader.expects(:open).yields(rss_io)
  loader
end

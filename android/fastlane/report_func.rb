def generate_report(service,strService)
    puts "Generating Test Report ..."
      sh 'xchtmlreport -v -r test_output_'+service+'/'+strService+'.test_result'
      puts "Test Report Successfully generated"
  end
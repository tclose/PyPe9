#ifndef UNIVERSAL_DATA_LOGGER_H
#define UNIVERSAL_DATA_LOGGER_H

namespace nest {

    class DataLoggingRequest {
      public:
        void handle(const SpikeEvent& e) {}
        void handle(const CurrentEvent& e) {}
    };


    template <class NodeType> class UniversalDataLogger {
      public:
        UniversalDataLogger() {}
        UniversalDataLogger(NodeType& node);
        ~UniversalDataLogger();
        port connect_logging_device(DataLoggingRequest& request,
                RecordablesMap<NodeType>& map);
        void init() {}
        void reset() {}
        void record_data(long_t step);
        void handle(const DataLoggingRequest& dlr) {}
      private:
        std::ofstream* output_file;
        NodeType* node_;
    };

    template <class NodeType> UniversalDataLogger<NodeType>::UniversalDataLogger(NodeType& node)
      : node_(&node) {
        std::string path = ::get_data_path<NodeType>();
        std::cout << "Writing output to " << path << std::endl;
        output_file = new std::ofstream(path);
    }

    template <class NodeType> UniversalDataLogger<NodeType>::~UniversalDataLogger() {
        delete output_file;
    }

    template <class NodeType> void UniversalDataLogger<NodeType>::record_data(long_t step) {
        if (!step) {
            (*output_file) << "# ";
            for (typename RecordablesMap<NodeType>::iterator it = node_->recordablesMap_.begin(); it != node_->recordablesMap_.end(); ++it)
                (*output_file) << it->first << " ";
            (*output_file) << std::endl;
        }
        for (typename RecordablesMap<NodeType>::iterator it = node_->recordablesMap_.begin(); it != node_->recordablesMap_.end(); ++it)
            (*output_file) << ((*node_).*(it->second))()  << " ";
        (*output_file) << std::endl;
    }

}

#endif
